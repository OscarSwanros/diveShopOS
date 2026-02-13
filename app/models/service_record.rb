# frozen_string_literal: true

class ServiceRecord < ApplicationRecord
  include Sluggable

  belongs_to :equipment_item

  slugged_by -> { "#{service_type&.humanize} #{service_date}" }, scope: :equipment_item_id

  enum :service_type, {
    annual_service: 0, repair: 1, inspection: 2,
    visual_inspection: 3, hydrostatic_test: 4
  }

  def cost
    cost_cents&./(100.0)
  end

  def cost=(val)
    self.cost_cents = val.present? ? (val.to_f * 100).round : nil
  end

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
