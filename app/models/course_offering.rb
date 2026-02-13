# frozen_string_literal: true

class CourseOffering < ApplicationRecord
  include Sluggable

  belongs_to :course
  belongs_to :organization
  belongs_to :instructor, class_name: "User"

  slugged_by -> { start_date&.strftime("%b-%Y") }, scope: :course_id

  has_many :class_sessions, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error

  enum :status, { draft: 0, published: 1, in_progress: 2, completed: 3, cancelled: 4 }

  validates :start_date, presence: true
  validates :max_students, presence: true, numericality: { greater_than: 0, only_integer: true }

  scope :upcoming, -> { where("start_date >= ?", Date.current).order(:start_date) }
  scope :past, -> { where("start_date < ?", Date.current).order(start_date: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :published_upcoming, -> { published.upcoming }

  def price
    price_cents&./(100.0)
  end

  def price=(val)
    self.price_cents = val.present? ? (val.to_f * 100).round : nil
  end

  def effective_price_cents
    price_cents || course.price_cents
  end

  def effective_price
    effective_price_cents / 100.0
  end

  def effective_price_currency
    price_currency.presence || course.price_currency
  end

  def spots_remaining
    max_students - enrollments.countable.count
  end

  def full?
    spots_remaining <= 0
  end
end
