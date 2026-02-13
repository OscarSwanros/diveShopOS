# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :organization

  has_many :api_tokens, dependent: :destroy
  has_many :instructor_ratings, dependent: :destroy
  has_many :taught_offerings, class_name: "CourseOffering", foreign_key: :instructor_id, dependent: :restrict_with_error

  has_secure_password

  enum :role, { staff: 0, manager: 1, owner: 2 }

  validates :email_address, presence: true, uniqueness: { scope: :organization_id }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
