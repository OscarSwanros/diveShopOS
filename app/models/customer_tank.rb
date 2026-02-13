# frozen_string_literal: true

class CustomerTank < ApplicationRecord
  belongs_to :customer
  belongs_to :organization

  validates :serial_number, presence: true, uniqueness: { scope: :organization_id }

  scope :compliant, -> { where("vip_due_date >= ? AND hydro_due_date >= ?", Date.current, Date.current) }
  scope :vip_expired, -> { where("vip_due_date < ? OR vip_due_date IS NULL", Date.current) }
  scope :hydro_expired, -> { where("hydro_due_date < ? OR hydro_due_date IS NULL", Date.current) }

  def vip_current?
    vip_due_date.present? && vip_due_date >= Date.current
  end

  def hydro_current?
    hydro_due_date.present? && hydro_due_date >= Date.current
  end

  def fill_compliant?
    vip_current? && hydro_current?
  end
end
