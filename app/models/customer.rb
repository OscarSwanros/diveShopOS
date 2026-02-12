# frozen_string_literal: true

class Customer < ApplicationRecord
  belongs_to :organization

  has_many :certifications, dependent: :destroy
  has_many :medical_records, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: { scope: :organization_id }, allow_nil: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { email.present? }

  normalizes :email, with: ->(e) { e.strip.downcase }

  scope :active, -> { where(active: true) }
  scope :by_name, -> { order(:last_name, :first_name) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def age(as_of: Date.current)
    return nil unless date_of_birth

    age = as_of.year - date_of_birth.year
    age -= 1 if as_of < date_of_birth + age.years
    age
  end

  def current_medical_clearance
    medical_records.kept.current_clearance.order(clearance_date: :desc).first
  end
end
