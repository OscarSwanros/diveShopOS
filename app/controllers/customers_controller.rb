# frozen_string_literal: true

class CustomersController < ApplicationController
  before_action :set_customer, only: [ :show, :edit, :update, :destroy ]

  def index
    @customers = policy_scope(current_organization.customers)
    @customers = @customers.by_name
  end

  def show
    @certifications = @customer.certifications.kept.order(issued_date: :desc)
    @customer_tanks = @customer.customer_tanks.order(created_at: :desc)
    @medical_records = @customer.medical_records.kept.order(created_at: :desc) if policy(MedicalRecord).show?
  end

  def new
    @customer = current_organization.customers.build
    authorize @customer
  end

  def create
    @customer = current_organization.customers.build(customer_params)
    authorize @customer

    if @customer.save
      redirect_to @customer, notice: I18n.t("customers.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: I18n.t("customers.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.update!(active: false)
    redirect_to customers_path, notice: I18n.t("customers.deactivated")
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
