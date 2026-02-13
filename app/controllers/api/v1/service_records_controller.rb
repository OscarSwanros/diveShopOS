# frozen_string_literal: true

module Api
  module V1
    class ServiceRecordsController < BaseController
      include ApiPagination

      before_action :set_equipment_item
      before_action :set_service_record, only: [ :show, :update, :destroy ]

      def index
        @service_records = paginate(@equipment_item.service_records.order(service_date: :desc))
      end

      def show
      end

      def create
        @service_record = @equipment_item.service_records.build(service_record_params)
        authorize @service_record

        if @service_record.save
          render :show, status: :created
        else
          render_validation_errors(@service_record)
        end
      end

      def update
        if @service_record.update(service_record_params)
          render :show
        else
          render_validation_errors(@service_record)
        end
      end

      def destroy
        @service_record.destroy
        head :no_content
      end

      private

      def set_equipment_item
        @equipment_item = find_by_slug_or_id(current_organization.equipment_items, params[:equipment_item_id])
      end

      def set_service_record
        @service_record = find_by_slug_or_id(@equipment_item.service_records, params[:id])
        authorize @service_record
      end

      def service_record_params
        params.require(:service_record).permit(
          :service_type, :service_date, :next_due_date, :performed_by,
          :cost, :cost_cents, :cost_currency, :description, :notes
        )
      end
    end
  end
end
