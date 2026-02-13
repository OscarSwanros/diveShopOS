# frozen_string_literal: true

module Public
  module Catalog
    class ExcursionsController < Public::BaseController
      def index
        @excursions = current_organization.excursions
          .published_upcoming
          .includes(trip_dives: :dive_site)
      end

      def show
        @excursion = current_organization.excursions
          .published
          .includes(trip_dives: :dive_site)
          .find_by!(slug: params[:id])
      end
    end
  end
end
