# frozen_string_literal: true

class CertificationsController < ApplicationController
  before_action :set_customer
  before_action :set_certification, only: [ :show, :edit, :update, :destroy ]

  def show
  end

  def new
    @certification = @customer.certifications.build
    authorize @certification
  end

  def create
    @certification = @customer.certifications.build(certification_params)
    authorize @certification

    if @certification.save
      redirect_to customer_path(@customer), notice: I18n.t("certifications.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @certification.update(certification_params)
      redirect_to customer_path(@customer), notice: I18n.t("certifications.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @certification.discard
    redirect_to customer_path(@customer), notice: I18n.t("certifications.deleted")
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
