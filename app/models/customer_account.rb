# frozen_string_literal: true

class CustomerAccount < ApplicationRecord
  include Sluggable

  belongs_to :organization
  belongs_to :customer

  has_secure_password

  # Override Rails default 15-minute expiry for password reset tokens
  generates_token_for :password_reset, expires_in: 2.hours do
    password_salt&.last(10)
  end

  slugged_by -> { customer.full_name }, scope: :organization_id

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :email, presence: true,
    uniqueness: { scope: :organization_id },
    format: { with: URI::MailTo::EMAIL_REGEXP }

  before_create :generate_confirmation_token

  def confirmed?
    confirmed_at.present?
  end

  def confirm!
    update!(confirmed_at: Time.current, confirmation_token: nil)
  end

  def generate_confirmation_token!
    update!(
      confirmation_token: SecureRandom.urlsafe_base64(32),
      confirmation_sent_at: Time.current
    )
  end

  def record_sign_in!(ip:)
    update!(last_sign_in_at: Time.current, last_sign_in_ip: ip)
  end

  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64(32)
    self.confirmation_sent_at = Time.current
  end
end
