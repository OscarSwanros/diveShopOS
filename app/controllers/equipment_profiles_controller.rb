# frozen_string_literal: true

class EquipmentProfilesController < ApplicationController
  before_action :set_customer
  before_action :set_equipment_profile, only: [ :show, :edit, :update, :destroy ]

  def show
  end

  def new
    @equipment_profile = @customer.build_equipment_profile
    authorize @equipment_profile
  end

  def create
    @equipment_profile = @customer.build_equipment_profile(equipment_profile_params)
    authorize @equipment_profile

    if @equipment_profile.save
      redirect_to customer_path(@customer), notice: I18n.t("equipment_profiles.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @equipment_profile.update(equipment_profile_params)
      redirect_to customer_path(@customer), notice: I18n.t("equipment_profiles.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @equipment_profile.destroy
    redirect_to customer_path(@customer), notice: I18n.t("equipment_profiles.deleted")
  end

  private

  def set_customer
    @customer = current_organization.customers.find_by!(slug: params[:customer_id])
  end

  def set_equipment_profile
    @equipment_profile = @customer.equipment_profile
    raise ActiveRecord::RecordNotFound unless @equipment_profile
    authorize @equipment_profile
  end

  def equipment_profile_params
    params.require(:equipment_profile).permit(
      :height_cm, :weight_kg, :wetsuit_size, :wetsuit_thickness_mm,
      :bcd_size, :boot_size, :fin_size, :glove_size,
      :owns_mask, :owns_computer, :owns_wetsuit, :owns_fins,
      :owns_bcd, :owns_regulator, :notes
    )
  end
end
