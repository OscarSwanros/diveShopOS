# frozen_string_literal: true

class ApiToken < ApplicationRecord
  belongs_to :user

  validates :token_digest, presence: true, uniqueness: true
  validates :name, presence: true

  scope :active, -> { where(revoked_at: nil).where("expires_at IS NULL OR expires_at > ?", Time.current) }

  def self.find_by_plain_token(plain_token)
    return nil if plain_token.blank?

    digest = Digest::SHA256.hexdigest(plain_token)
    active.find_by(token_digest: digest)
  end

  def self.generate_token_pair(user:, name:, expires_at: nil)
    plain_token = SecureRandom.hex(32)
    digest = Digest::SHA256.hexdigest(plain_token)

    token = user.api_tokens.create!(
      token_digest: digest,
      name: name,
      expires_at: expires_at
    )

    [ token, plain_token ]
  end

  def revoke!
    update!(revoked_at: Time.current)
  end

  def revoked?
    revoked_at.present?
  end

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  def active?
    !revoked? && !expired?
  end

  def touch_last_used!
    update_column(:last_used_at, Time.current)
  end
end
