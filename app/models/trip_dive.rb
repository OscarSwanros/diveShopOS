# frozen_string_literal: true

class TripDive < ApplicationRecord
  include Sluggable

  belongs_to :excursion
  belongs_to :dive_site

  slugged_by -> { "dive #{dive_number}" }, scope: :excursion_id

  validates :dive_number, presence: true,
    numericality: { greater_than: 0, only_integer: true },
    uniqueness: { scope: :excursion_id }
  validates :planned_max_depth_meters, numericality: { greater_than: 0 }, allow_nil: true
  validates :planned_bottom_time_minutes, numericality: { greater_than: 0, only_integer: true }, allow_nil: true

  delegate :organization, to: :excursion
end
