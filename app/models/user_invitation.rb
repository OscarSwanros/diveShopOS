# frozen_string_literal: true

class UserInvitation < ApplicationRecord
  belongs_to :organization
  belongs_to :invited_by, class_name: "User"

  enum :role, { staff: 0, manager: 1, owner: 2 }

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :token_digest, presence: true, uniqueness: true
  validates :expires_at, presence: true

  normalizes :email, with: ->(e) { e.strip.downcase }

  scope :pending, -> { where(accepted_at: nil).where("expires_at > ?", Time.current) }
  scope :expired, -> { where(accepted_at: nil).where("expires_at <= ?", Time.current) }

  def accepted?
    accepted_at.present?
  end

  def expired?
    !accepted? && expires_at < Time.current
  end

  def pending?
    !accepted? && expires_at > Time.current
  end

  def self.find_by_token(token)
    return nil if token.blank?

    digest = Digest::SHA256.hexdigest(token)
    find_by(token_digest: digest)
  end
end
