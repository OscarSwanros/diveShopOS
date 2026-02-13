# frozen_string_literal: true

class MedicalRecordsController < ApplicationController
  before_action :set_customer, except: [ :index ]
  before_action :set_medical_record, only: [ :show, :edit, :update, :destroy ]

  def index
    authorize MedicalRecord

    @medical_records = policy_scope(MedicalRecord).kept.includes(:customer)

    case params[:status]
    when "pending_review"
      @medical_records = @medical_records.pending_review
    when "cleared"
      @medical_records = @medical_records.cleared
    when "not_cleared"
      @medical_records = @medical_records.not_cleared
    when "expired"
      @medical_records = @medical_records.expired
    end

    @medical_records = @medical_records.order(created_at: :desc)
  end

  def show
  end

  def new
    @medical_record = @customer.medical_records.build
    authorize @medical_record
  end

  def create
    @medical_record = @customer.medical_records.build(medical_record_params)
    authorize @medical_record

    if @medical_record.save
      redirect_to customer_path(@customer), notice: I18n.t("medical_records.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @medical_record.update(medical_record_params)
      redirect_to customer_path(@customer), notice: I18n.t("medical_records.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medical_record.discard
    redirect_to customer_path(@customer), notice: I18n.t("medical_records.deleted")
  end

  private

  def set_customer
    @customer = current_organization.customers.find_by!(slug: params[:customer_id])
  end

  def set_medical_record
    @medical_record = @customer.medical_records.kept.find_by!(slug: params[:id])
    authorize @medical_record
  end

  def medical_record_params
    params.require(:medical_record).permit(
      :status, :clearance_date, :expiration_date, :physician_name, :notes
    )
  end
end
