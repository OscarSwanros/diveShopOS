# frozen_string_literal: true

class EquipmentItemsController < ApplicationController
  before_action :set_equipment_item, only: [ :show, :edit, :update, :destroy ]

  def index
    @equipment_items = policy_scope(current_organization.equipment_items)

    @equipment_items = @equipment_items.by_category(params[:category]) if params[:category].present?
    @equipment_items = @equipment_items.where(status: params[:status]) if params[:status].present?
    @equipment_items = @equipment_items.by_size(params[:size]) if params[:size].present?
    @equipment_items = @equipment_items.order(:category, :name)
  end

  def show
    @service_records = @equipment_item.service_records.order(service_date: :desc)
  end

  def new
    @equipment_item = current_organization.equipment_items.build
    authorize @equipment_item
  end

  def create
    @equipment_item = current_organization.equipment_items.build(equipment_item_params)
    authorize @equipment_item

    if @equipment_item.save
      redirect_to @equipment_item, notice: I18n.t("equipment_items.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @equipment_item.update(equipment_item_params)
      redirect_to @equipment_item, notice: I18n.t("equipment_items.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @equipment_item.destroy
    redirect_to equipment_items_path, notice: I18n.t("equipment_items.deleted")
  end

  private

  def set_equipment_item
    @equipment_item = current_organization.equipment_items.find_by!(slug: params[:id])
    authorize @equipment_item
  end

  def equipment_item_params
    params.require(:equipment_item).permit(
      :category, :name, :serial_number, :size, :manufacturer, :product_model,
      :status, :life_support, :purchase_date, :notes
    )
  end
end
