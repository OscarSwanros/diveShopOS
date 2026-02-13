# frozen_string_literal: true

module Api
  module V1
    class ExcursionsController < BaseController
      include ApiPagination

      before_action :set_excursion, only: [ :show, :update, :destroy ]

      def index
        scope = policy_scope(current_organization.excursions)
        scope = scope.by_status(params[:status]) if params[:status].present?
        @excursions = paginate(scope.order(scheduled_date: :desc))
      end

      def show
      end

      def create
        @excursion = current_organization.excursions.build(excursion_params)
        authorize @excursion

        if @excursion.save
          render :show, status: :created
        else
          render_validation_errors(@excursion)
        end
      end

      def update
        if @excursion.update(excursion_params)
          render :show
        else
          render_validation_errors(@excursion)
        end
      end

      def destroy
        @excursion.destroy
        head :no_content
      end

      private

      def set_excursion
        @excursion = current_organization.excursions.find(params[:id])
        authorize @excursion
      end

      def excursion_params
        params.require(:excursion).permit(
          :title, :description, :scheduled_date, :departure_time, :return_time,
          :capacity, :price_cents, :price_currency, :status, :notes
        )
      end
    end
  end
end
