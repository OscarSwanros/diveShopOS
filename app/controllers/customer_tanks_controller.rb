# frozen_string_literal: true

class CustomerTanksController < ApplicationController
  before_action :set_customer
  before_action :set_customer_tank, only: [ :show, :edit, :update, :destroy ]

  def index
    @customer_tanks = @customer.customer_tanks.order(created_at: :desc)
  end

  def show
  end

  def new
    @customer_tank = @customer.customer_tanks.build(organization: current_organization)
    authorize @customer_tank
  end

  def create
    @customer_tank = @customer.customer_tanks.build(customer_tank_params)
    @customer_tank.organization = current_organization
    authorize @customer_tank

    if @customer_tank.save
      redirect_to customer_path(@customer), notice: I18n.t("customer_tanks.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @customer_tank.update(customer_tank_params)
      redirect_to customer_path(@customer), notice: I18n.t("customer_tanks.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer_tank.destroy
    redirect_to customer_path(@customer), notice: I18n.t("customer_tanks.deleted")
  end

  private

  def set_customer
    @customer = current_organization.customers.find_by!(slug: params[:customer_id])
  end

  def set_customer_tank
    @customer_tank = @customer.customer_tanks.find_by!(slug: params[:id])
    authorize @customer_tank
  end

  def customer_tank_params
    params.require(:customer_tank).permit(
      :serial_number, :manufacturer, :material, :size,
      :last_vip_date, :vip_due_date, :last_hydro_date, :hydro_due_date, :notes
    )
  end
end
