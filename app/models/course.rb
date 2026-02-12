# frozen_string_literal: true

class Course < ApplicationRecord
  belongs_to :organization

  has_many :course_offerings, dependent: :restrict_with_error

  enum :course_type, {
    certification: 0,
    specialty: 1,
    non_certification: 2,
    professional: 3,
    continuing_education: 4
  }

  validates :name, presence: true, uniqueness: { scope: :organization_id }
  validates :agency, presence: true
  validates :level, presence: true
  validates :max_students, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :price_cents, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  scope :active, -> { where(active: true) }
  scope :by_agency, ->(agency) { where(agency: agency) }
  scope :by_type, ->(type) { where(course_type: type) }
end
