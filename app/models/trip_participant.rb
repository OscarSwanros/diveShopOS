# frozen_string_literal: true

class TripParticipant < ApplicationRecord
  include Sluggable

  belongs_to :excursion

  slugged_by :name, scope: :excursion_id

  enum :role, { diver: 0, guide: 1, divemaster: 2, instructor: 3 }

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :role, presence: true

  delegate :organization, to: :excursion
end
