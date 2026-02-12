# frozen_string_literal: true

class TripDivesController < ApplicationController
  before_action :set_excursion
  before_action :set_trip_dive, only: [ :edit, :update, :destroy ]

  def new
    @trip_dive = @excursion.trip_dives.build
    authorize @trip_dive
    @dive_sites = current_organization.dive_sites.active.order(:name)
  end

  def create
    @trip_dive = @excursion.trip_dives.build(trip_dive_params)
    authorize @trip_dive

    if @trip_dive.save
      redirect_to @excursion, notice: I18n.t("trip_dives.created")
    else
      @dive_sites = current_organization.dive_sites.active.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @dive_sites = current_organization.dive_sites.active.order(:name)
  end

  def update
    if @trip_dive.update(trip_dive_params)
      redirect_to @excursion, notice: I18n.t("trip_dives.updated")
    else
      @dive_sites = current_organization.dive_sites.active.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @trip_dive.destroy
    redirect_to @excursion, notice: I18n.t("trip_dives.deleted")
  end

  private

  def set_excursion
    @excursion = current_organization.excursions.find(params[:excursion_id])
  end

  def set_trip_dive
    @trip_dive = @excursion.trip_dives.find(params[:id])
    authorize @trip_dive
  end

  def trip_dive_params
    params.require(:trip_dive).permit(
      :dive_site_id, :dive_number, :planned_max_depth_meters,
      :planned_bottom_time_minutes, :notes
    )
  end
end
