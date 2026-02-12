# frozen_string_literal: true

class ClassSession < ApplicationRecord
  belongs_to :course_offering
  belongs_to :dive_site, optional: true

  has_many :session_attendances, dependent: :destroy

  enum :session_type, { classroom: 0, confined_water: 1, open_water: 2 }

  validates :scheduled_date, presence: true
  validates :start_time, presence: true

  scope :by_date, -> { order(:scheduled_date, :start_time) }
  scope :water_sessions, -> { where(session_type: [ :confined_water, :open_water ]) }

  delegate :organization, :instructor, to: :course_offering

  def water_session?
    confined_water? || open_water?
  end
end
