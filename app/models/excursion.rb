# frozen_string_literal: true

class Excursion < ApplicationRecord
  include Sluggable

  belongs_to :organization

  slugged_by -> { "#{title} #{scheduled_date&.strftime('%b-%Y')}" }, scope: :organization_id

  has_many :trip_dives, dependent: :destroy
  has_many :trip_participants, dependent: :destroy
  has_many :dive_sites, through: :trip_dives

  enum :status, { draft: 0, published: 1, cancelled: 2, completed: 3 }

  validates :title, presence: true
  validates :scheduled_date, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :price_cents, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  def price
    price_cents / 100.0
  end

  def price=(val)
    self.price_cents = (val.to_f * 100).round
  end
  validates :status, presence: true

  scope :upcoming, -> { where("scheduled_date >= ?", Date.current).order(:scheduled_date) }
  scope :past, -> { where("scheduled_date < ?", Date.current).order(scheduled_date: :desc) }
  scope :by_status, ->(status) { where(status: status) }

  def spots_remaining
    capacity - trip_participants.count
  end

  def full?
    spots_remaining <= 0
  end
end
