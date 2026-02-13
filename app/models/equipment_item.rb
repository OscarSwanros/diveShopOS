# frozen_string_literal: true

class EquipmentItem < ApplicationRecord
  include Sluggable

  belongs_to :organization

  slugged_by :name, scope: :organization_id

  has_many :service_records, dependent: :destroy

  enum :category, {
    fins: 0, bcd: 1, regulator: 2, mask: 3, wetsuit: 4,
    tank: 5, boots: 6, gloves: 7, weights: 8, computer: 9
  }

  enum :status, { available: 0, assigned: 1, in_service: 2, retired: 3 }

  validates :name, presence: true
  validates :category, presence: true
  validates :serial_number, uniqueness: { scope: :organization_id }, allow_nil: true
  validate :serial_number_required_for_life_support

  scope :active, -> { where.not(status: :retired) }
  scope :by_category, ->(cat) { where(category: cat) }
  scope :by_size, ->(size) { where(size: size) }

  def service_current?
    return true unless life_support?
    next_service_due.present? && next_service_due >= Date.current
  end

  def service_overdue?
    return false unless life_support?
    next_service_due.blank? || next_service_due < Date.current
  end

  private

  def serial_number_required_for_life_support
    if life_support? && serial_number.blank?
      errors.add(:serial_number, :blank)
    end
  end
end
