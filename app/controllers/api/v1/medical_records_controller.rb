# frozen_string_literal: true

module Api
  module V1
    class MedicalRecordsController < BaseController
      include ApiPagination

      before_action :set_customer
      before_action :set_medical_record, only: [ :show, :update, :destroy ]

      def index
        authorize MedicalRecord
        @medical_records = paginate(@customer.medical_records.kept.order(created_at: :desc))
      end

      def show
      end

      def create
        @medical_record = @customer.medical_records.build(medical_record_params)
        authorize @medical_record

        if @medical_record.save
          render :show, status: :created
        else
          render_validation_errors(@medical_record)
        end
      end

      def update
        if @medical_record.update(medical_record_params)
          render :show
        else
          render_validation_errors(@medical_record)
        end
      end

      def destroy
        @medical_record.discard
        head :no_content
      end

      private

      def set_customer
        @customer = current_organization.customers.find(params[:customer_id])
      end

      def set_medical_record
        @medical_record = @customer.medical_records.kept.find(params[:id])
        authorize @medical_record
      end

      def medical_record_params
        params.require(:medical_record).permit(
          :status, :clearance_date, :expiration_date, :physician_name, :notes
        )
      end
    end
  end
end
