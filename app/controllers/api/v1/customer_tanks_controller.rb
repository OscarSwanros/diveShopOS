# frozen_string_literal: true

module Api
  module V1
    class CustomerTanksController < BaseController
      include ApiPagination

      before_action :set_customer
      before_action :set_customer_tank, only: [ :show, :update, :destroy ]

      def index
        @customer_tanks = paginate(@customer.customer_tanks.order(created_at: :desc))
      end

      def show
      end

      def create
        @customer_tank = @customer.customer_tanks.build(customer_tank_params)
        @customer_tank.organization = current_organization
        authorize @customer_tank

        if @customer_tank.save
          render :show, status: :created
        else
          render_validation_errors(@customer_tank)
        end
      end

      def update
        if @customer_tank.update(customer_tank_params)
          render :show
        else
          render_validation_errors(@customer_tank)
        end
      end

      def destroy
        @customer_tank.destroy
        head :no_content
      end

      private

      def set_customer
        @customer = current_organization.customers.find(params[:customer_id])
      end

      def set_customer_tank
        @customer_tank = @customer.customer_tanks.find(params[:id])
        authorize @customer_tank
      end

      def customer_tank_params
        params.require(:customer_tank).permit(
          :serial_number, :manufacturer, :material, :size,
          :last_vip_date, :vip_due_date, :last_hydro_date, :hydro_due_date, :notes
        )
      end
    end
  end
end
