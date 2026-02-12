# frozen_string_literal: true

class InstructorRating < ApplicationRecord
  belongs_to :user

  validates :agency, presence: true
  validates :rating_level, presence: true
  validates :rating_level, uniqueness: { scope: [ :user_id, :agency ] }

  scope :active, -> { where(active: true) }
  scope :current, -> { active.where("expiration_date IS NULL OR expiration_date >= ?", Date.current) }
  scope :for_agency, ->(agency) { where(agency: agency) }

  def expired?
    expiration_date.present? && expiration_date < Date.current
  end

  def current?
    active? && !expired?
  end
end
