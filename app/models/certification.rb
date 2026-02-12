# frozen_string_literal: true

class Certification < ApplicationRecord
  belongs_to :customer
  belongs_to :issuing_organization, class_name: "Organization", optional: true

  validates :agency, presence: true
  validates :certification_level, presence: true

  scope :kept, -> { where(discarded_at: nil) }
  scope :discarded, -> { where.not(discarded_at: nil) }
  scope :active, -> { kept.where("expiration_date IS NULL OR expiration_date >= ?", Date.current) }
  scope :expired, -> { kept.where("expiration_date < ?", Date.current) }

  def discard
    update!(discarded_at: Time.current)
  end

  def discarded?
    discarded_at.present?
  end

  def expired?
    expiration_date.present? && expiration_date < Date.current
  end

  def active?
    !discarded? && !expired?
  end
end
