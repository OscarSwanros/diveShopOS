# frozen_string_literal: true

class DiveSite < ApplicationRecord
  belongs_to :organization

  has_many :trip_dives, dependent: :restrict_with_error

  enum :difficulty_level, { beginner: 0, intermediate: 1, advanced: 2, expert: 3 }

  validates :name, presence: true, uniqueness: { scope: :organization_id }
  validates :difficulty_level, presence: true
  validates :max_depth_meters, numericality: { greater_than: 0 }, allow_nil: true
  validates :latitude, numericality: { in: -90..90 }, allow_nil: true
  validates :longitude, numericality: { in: -180..180 }, allow_nil: true

  scope :active, -> { where(active: true) }
  scope :by_difficulty, ->(level) { where(difficulty_level: level) }
end
