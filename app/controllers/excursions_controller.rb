# frozen_string_literal: true

class ExcursionsController < ApplicationController
  before_action :set_excursion, only: [ :show, :edit, :update, :destroy ]

  def index
    @excursions = policy_scope(current_organization.excursions)

    @excursions = @excursions.by_status(params[:status]) if params[:status].present?
    @excursions = @excursions.order(scheduled_date: :desc)
  end

  def show
    @trip_dives = @excursion.trip_dives.includes(:dive_site).order(:dive_number)
    @trip_participants = @excursion.trip_participants.order(:name)
  end

  def new
    @excursion = current_organization.excursions.build(scheduled_date: Date.current)
    authorize @excursion
  end

  def create
    @excursion = current_organization.excursions.build(excursion_params)
    authorize @excursion

    if @excursion.save
      redirect_to @excursion, notice: I18n.t("excursions.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @excursion.update(excursion_params)
      redirect_to @excursion, notice: I18n.t("excursions.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @excursion.destroy
    redirect_to excursions_path, notice: I18n.t("excursions.deleted")
  end

  private

  def set_excursion
    @excursion = current_organization.excursions.find_by!(slug: params[:id])
    authorize @excursion
  end

  def excursion_params
    params.require(:excursion).permit(
      :title, :description, :scheduled_date, :departure_time, :return_time,
      :capacity, :price, :price_currency, :status, :notes
    )
  end
end
