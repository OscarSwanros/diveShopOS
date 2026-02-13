# frozen_string_literal: true

class WaitlistEntry < ApplicationRecord
  include Sluggable

  belongs_to :organization
  belongs_to :customer
  belongs_to :waitlistable, polymorphic: true

  slugged_by -> { "#{customer.full_name}-#{waitlistable_type.underscore.dasherize}" }, scope: :organization_id

  enum :status, { waiting: 0, notified: 1, converted: 2, expired: 3, cancelled: 4 }

  validates :position, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :customer_id, uniqueness: {
    scope: [ :waitlistable_type, :waitlistable_id ],
    conditions: -> { waiting }
  }

  scope :active, -> { where(status: :waiting) }
  scope :by_position, -> { order(:position) }

  def notify!
    update!(status: :notified, notified_at: Time.current, expires_at: 48.hours.from_now)
  end

  def convert!
    update!(status: :converted)
  end

  def expire!
    update!(status: :expired)
  end

  def cancel!
    update!(status: :cancelled)
  end
end
