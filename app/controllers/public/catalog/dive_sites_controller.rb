# frozen_string_literal: true

module Public
  module Catalog
    class DiveSitesController < Public::BaseController
      def index
        @dive_sites = current_organization.dive_sites
          .active
          .order(:name)
      end

      def show
        @dive_site = current_organization.dive_sites
          .active
          .find_by!(slug: params[:id])
        @upcoming_excursions = current_organization.excursions
          .published_upcoming
          .joins(trip_dives: :dive_site)
          .where(dive_sites: { id: @dive_site.id })
          .distinct
      end
    end
  end
end
