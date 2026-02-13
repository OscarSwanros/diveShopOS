# frozen_string_literal: true

class TripParticipant < ApplicationRecord
  include Sluggable

  belongs_to :excursion
  belongs_to :customer, optional: true

  slugged_by :name, scope: :excursion_id

  enum :role, { diver: 0, guide: 1, divemaster: 2, instructor: 3, snorkeler: 4, observer: 5 }
  enum :status, { tp_requested: 0, tp_confirmed: 1, tp_cancelled: 2 }, prefix: :booking

  serialize :safety_gate_results, coder: JSON

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :role, presence: true
  validates :customer_id, uniqueness: { scope: :excursion_id, conditions: -> { where.not(status: :tp_cancelled) } }, allow_nil: true

  scope :review_queue, -> { where(status: :tp_requested).order(created_at: :asc) }
  scope :confirmed_or_legacy, -> { where("trip_participants.status IS NULL OR trip_participants.status = ?", statuses[:tp_confirmed]) }

  delegate :organization, to: :excursion

  def decline!(reason:)
    update!(status: :tp_cancelled, declined_at: Time.current, declined_reason: reason)
  end
end
