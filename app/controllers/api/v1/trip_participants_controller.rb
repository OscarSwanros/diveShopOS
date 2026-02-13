# frozen_string_literal: true

module Api
  module V1
    class TripParticipantsController < BaseController
      include ApiPagination

      before_action :set_excursion
      before_action :set_trip_participant, only: [ :show, :update, :destroy ]

      def index
        @trip_participants = paginate(@excursion.trip_participants.order(:name))
      end

      def show
      end

      def create
        @trip_participant = @excursion.trip_participants.build(trip_participant_params)
        authorize @trip_participant

        capacity_result = Excursions::CheckCapacity.new(excursion: @excursion).call
        unless capacity_result.success
          return render_safety_gate_failure(capacity_result)
        end

        if @trip_participant.save
          render :show, status: :created
        else
          render_validation_errors(@trip_participant)
        end
      end

      def update
        if @trip_participant.update(trip_participant_params)
          render :show
        else
          render_validation_errors(@trip_participant)
        end
      end

      def destroy
        @trip_participant.destroy
        head :no_content
      end

      private

      def set_excursion
        @excursion = current_organization.excursions.find(params[:excursion_id])
      end

      def set_trip_participant
        @trip_participant = @excursion.trip_participants.find(params[:id])
        authorize @trip_participant
      end

      def trip_participant_params
        params.require(:trip_participant).permit(
          :name, :email, :phone, :certification_level,
          :certification_agency, :role, :notes, :paid
        )
      end
    end
  end
end
