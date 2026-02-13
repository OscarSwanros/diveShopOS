# frozen_string_literal: true

class Enrollment < ApplicationRecord
  include Sluggable

  belongs_to :course_offering
  belongs_to :customer
  belongs_to :certification, optional: true

  slugged_by -> { customer.full_name }, scope: :course_offering_id

  has_many :session_attendances, dependent: :destroy

  enum :status, { pending: 0, confirmed: 1, active: 2, completed: 3, withdrawn: 4, failed: 5 }

  validates :customer_id, uniqueness: { scope: :course_offering_id }

  scope :active_enrollments, -> { where(status: [ :pending, :confirmed, :active ]) }
  scope :countable, -> { where.not(status: [ :withdrawn, :failed ]) }

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
