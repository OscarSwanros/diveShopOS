# frozen_string_literal: true

module Api
  module V1
    class DiveSitesController < BaseController
      include ApiPagination

      before_action :set_dive_site, only: [ :show, :update, :destroy ]

      def index
        @dive_sites = paginate(policy_scope(current_organization.dive_sites).order(:name))
      end

      def show
      end

      def create
        @dive_site = current_organization.dive_sites.build(dive_site_params)
        authorize @dive_site

        if @dive_site.save
          render :show, status: :created
        else
          render_validation_errors(@dive_site)
        end
      end

      def update
        if @dive_site.update(dive_site_params)
          render :show
        else
          render_validation_errors(@dive_site)
        end
      end

      def destroy
        @dive_site.destroy
        head :no_content
      end

      private

      def set_dive_site
        @dive_site = find_by_slug_or_id(current_organization.dive_sites, params[:id])
        authorize @dive_site
      end

      def dive_site_params
        params.require(:dive_site).permit(
          :name, :description, :max_depth_meters, :difficulty_level,
          :latitude, :longitude, :location_description, :active
        )
      end
    end
  end
end
