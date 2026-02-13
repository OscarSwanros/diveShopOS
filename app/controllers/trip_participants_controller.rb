# frozen_string_literal: true

class TripParticipantsController < ApplicationController
  before_action :set_excursion
  before_action :set_trip_participant, only: [ :edit, :update, :destroy ]

  def new
    @trip_participant = @excursion.trip_participants.build
    authorize @trip_participant
  end

  def create
    @trip_participant = @excursion.trip_participants.build(trip_participant_params)
    authorize @trip_participant

    capacity_result = Excursions::CheckCapacity.new(excursion: @excursion).call
    unless capacity_result.success
      @trip_participant.errors.add(:base, capacity_result.reason)
      return render :new, status: :unprocessable_entity
    end

    if @trip_participant.save
      redirect_to @excursion, notice: I18n.t("trip_participants.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @trip_participant.update(trip_participant_params)
      redirect_to @excursion, notice: I18n.t("trip_participants.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @trip_participant.destroy
    redirect_to @excursion, notice: I18n.t("trip_participants.deleted")
  end

  private

  def set_excursion
    @excursion = current_organization.excursions.find_by!(slug: params[:excursion_id])
  end

  def set_trip_participant
    @trip_participant = @excursion.trip_participants.find_by!(slug: params[:id])
    authorize @trip_participant
  end

  def trip_participant_params
    params.require(:trip_participant).permit(
      :name, :email, :phone, :certification_level,
      :certification_agency, :role, :notes, :paid
    )
  end
end
