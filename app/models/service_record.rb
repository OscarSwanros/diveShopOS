# frozen_string_literal: true

class ServiceRecord < ApplicationRecord
  belongs_to :equipment_item

  enum :service_type, {
    annual_service: 0, repair: 1, inspection: 2,
    visual_inspection: 3, hydrostatic_test: 4
  }

  validates :service_type, presence: true
  validates :service_date, presence: true
  validates :performed_by, presence: true

  after_save :update_equipment_item_service_dates

  private

  def update_equipment_item_service_dates
    latest = equipment_item.service_records.order(service_date: :desc).first
    equipment_item.update_columns(
      last_service_date: latest.service_date,
      next_service_due: latest.next_due_date
    )
  end
end
