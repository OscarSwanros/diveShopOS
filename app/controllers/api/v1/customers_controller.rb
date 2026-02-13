# frozen_string_literal: true

module Api
  module V1
    class CustomersController < BaseController
      include ApiPagination

      before_action :set_customer, only: [ :show, :update, :destroy ]

      def index
        @customers = paginate(policy_scope(current_organization.customers).by_name)
      end

      def show
      end

      def create
        @customer = current_organization.customers.build(customer_params)
        authorize @customer

        if @customer.save
          render :show, status: :created
        else
          render_validation_errors(@customer)
        end
      end

      def update
        if @customer.update(customer_params)
          render :show
        else
          render_validation_errors(@customer)
        end
      end

      def destroy
        @customer.update!(active: false)
        head :no_content
      end

      private

      def set_customer
        @customer = current_organization.customers.find(params[:id])
        authorize @customer
      end

      def customer_params
        params.require(:customer).permit(
          :first_name, :last_name, :email, :phone, :date_of_birth,
          :emergency_contact_name, :emergency_contact_phone, :notes
        )
      end
    end
  end
end
