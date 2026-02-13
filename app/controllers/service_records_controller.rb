# frozen_string_literal: true

class ServiceRecordsController < ApplicationController
  before_action :set_equipment_item
  before_action :set_service_record, only: [ :show, :edit, :update, :destroy ]

  def show
  end

  def new
    @service_record = @equipment_item.service_records.build
    authorize @service_record
  end

  def create
    @service_record = @equipment_item.service_records.build(service_record_params)
    authorize @service_record

    if @service_record.save
      redirect_to @equipment_item, notice: I18n.t("service_records.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @service_record.update(service_record_params)
      redirect_to @equipment_item, notice: I18n.t("service_records.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @service_record.destroy
    redirect_to @equipment_item, notice: I18n.t("service_records.deleted")
  end

  private

  def set_equipment_item
    @equipment_item = current_organization.equipment_items.find_by!(slug: params[:equipment_item_id])
  end

  def set_service_record
    @service_record = @equipment_item.service_records.find_by!(slug: params[:id])
    authorize @service_record
  end

  def service_record_params
    params.require(:service_record).permit(
      :service_type, :service_date, :next_due_date, :performed_by,
      :cost, :cost_currency, :description, :notes
    )
  end
end
