# frozen_string_literal: true

module Api
  module V1
    class CertificationsController < BaseController
      include ApiPagination

      before_action :set_customer
      before_action :set_certification, only: [ :show, :update, :destroy ]

      def index
        @certifications = paginate(@customer.certifications.kept.order(issued_date: :desc))
      end

      def show
      end

      def create
        @certification = @customer.certifications.build(certification_params)
        authorize @certification

        if @certification.save
          render :show, status: :created
        else
          render_validation_errors(@certification)
        end
      end

      def update
        if @certification.update(certification_params)
          render :show
        else
          render_validation_errors(@certification)
        end
      end

      def destroy
        @certification.discard
        head :no_content
      end

      private

      def set_customer
        @customer = current_organization.customers.find(params[:customer_id])
      end

      def set_certification
        @certification = @customer.certifications.kept.find(params[:id])
        authorize @certification
      end

      def certification_params
        params.require(:certification).permit(
          :agency, :certification_level, :certification_number,
          :issued_date, :expiration_date, :notes
        )
      end
    end
  end
end
