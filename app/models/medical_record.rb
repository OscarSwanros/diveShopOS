# frozen_string_literal: true

class MedicalRecord < ApplicationRecord
  belongs_to :customer

  enum :status, { pending_review: 0, cleared: 1, not_cleared: 2, expired: 3 }

  validates :status, presence: true

  scope :kept, -> { where(discarded_at: nil) }
  scope :discarded, -> { where.not(discarded_at: nil) }
  scope :current_clearance, -> { cleared.where("expiration_date IS NULL OR expiration_date >= ?", Date.current) }

  def valid_clearance?
    cleared? && !discarded? && (expiration_date.nil? || expiration_date >= Date.current)
  end

  def discard
    update!(discarded_at: Time.current)
  end

  def discarded?
    discarded_at.present?
  end
end
