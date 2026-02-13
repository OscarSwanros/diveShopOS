# frozen_string_literal: true

module Api
  module V1
    class TripDivesController < BaseController
      include ApiPagination

      before_action :set_excursion
      before_action :set_trip_dive, only: [ :show, :update, :destroy ]

      def index
        @trip_dives = paginate(@excursion.trip_dives.includes(:dive_site).order(:dive_number))
      end

      def show
      end

      def create
        @trip_dive = @excursion.trip_dives.build(trip_dive_params)
        authorize @trip_dive

        if @trip_dive.save
          render :show, status: :created
        else
          render_validation_errors(@trip_dive)
        end
      end

      def update
        if @trip_dive.update(trip_dive_params)
          render :show
        else
          render_validation_errors(@trip_dive)
        end
      end

      def destroy
        @trip_dive.destroy
        head :no_content
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
  end
end
