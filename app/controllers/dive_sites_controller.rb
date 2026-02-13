# frozen_string_literal: true

class DiveSitesController < ApplicationController
  before_action :set_dive_site, only: [ :show, :edit, :update, :destroy ]

  def index
    @dive_sites = policy_scope(current_organization.dive_sites).order(:name)
  end

  def show
  end

  def new
    @dive_site = current_organization.dive_sites.build
    authorize @dive_site
  end

  def create
    @dive_site = current_organization.dive_sites.build(dive_site_params)
    authorize @dive_site

    if @dive_site.save
      redirect_to @dive_site, notice: I18n.t("dive_sites.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @dive_site.update(dive_site_params)
      redirect_to @dive_site, notice: I18n.t("dive_sites.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @dive_site.destroy
    redirect_to dive_sites_path, notice: I18n.t("dive_sites.deleted")
  end

  private

  def set_dive_site
    @dive_site = current_organization.dive_sites.find_by!(slug: params[:id])
    authorize @dive_site
  end

  def dive_site_params
    params.require(:dive_site).permit(
      :name, :description, :max_depth_meters, :difficulty_level,
      :latitude, :longitude, :location_description, :active
    )
  end
end
