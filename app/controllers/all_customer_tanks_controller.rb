# frozen_string_literal: true

class AllCustomerTanksController < ApplicationController
  def index
    authorize :all_customer_tanks

    @customer_tanks = current_organization.customer_tanks.includes(:customer)

    case params[:compliance]
    when "compliant"
      @customer_tanks = @customer_tanks.compliant
    when "noncompliant"
      @customer_tanks = @customer_tanks.vip_expired.or(current_organization.customer_tanks.hydro_expired)
    end

    @customer_tanks = @customer_tanks.order(:serial_number)
  end
end
