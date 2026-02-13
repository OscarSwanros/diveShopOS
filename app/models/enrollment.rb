# frozen_string_literal: true

class Enrollment < ApplicationRecord
  include Sluggable

  belongs_to :course_offering
  belongs_to :customer
  belongs_to :certification, optional: true

  slugged_by -> { customer.full_name }, scope: :course_offering_id

  has_many :session_attendances, dependent: :destroy

  enum :status, { pending: 0, confirmed: 1, active: 2, completed: 3, withdrawn: 4, failed: 5, requested: 6, declined: 7 }

  serialize :safety_gate_results, coder: JSON

  validates :customer_id, uniqueness: { scope: :course_offering_id, conditions: -> { where.not(status: [ :withdrawn, :failed, :declined ]) } }

  scope :active_enrollments, -> { where(status: [ :pending, :confirmed, :active ]) }
  scope :countable, -> { where.not(status: [ :withdrawn, :failed, :declined, :requested ]) }
  scope :review_queue, -> { requested.order(created_at: :asc) }

  def decline!(reason:)
    update!(status: :declined, declined_at: Time.current, declined_reason: reason)
  end

  def complete!(certification: nil)
    update!(
      status: :completed,
      completed_at: Time.current,
      certification: certification
    )
  end

  def withdraw!
    update!(status: :withdrawn)
  end
end
