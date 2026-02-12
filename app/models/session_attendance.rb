# frozen_string_literal: true

class SessionAttendance < ApplicationRecord
  belongs_to :class_session
  belongs_to :enrollment

  validates :enrollment_id, uniqueness: { scope: :class_session_id }

  delegate :customer, to: :enrollment
  delegate :course_offering, to: :class_session
end
