# frozen_string_literal: true

class Organization < ApplicationRecord
  RESERVED_SUBDOMAINS = %w[
    www api mail admin app help support status blog docs cdn assets static
    staging dev test demo billing payments portal
  ].freeze

  DOMAIN_FORMAT = /\A[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)*\.[a-z]{2,}\z/

  has_many :users, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :customer_accounts, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :course_offerings, dependent: :destroy
  has_many :dive_sites, dependent: :destroy
  has_many :excursions, dependent: :destroy
  has_many :equipment_items, dependent: :destroy
  has_many :customer_tanks, dependent: :destroy
  has_many :checklist_templates, dependent: :destroy
  has_many :checklist_runs, dependent: :destroy
  has_many :user_invitations, dependent: :destroy

  has_one_attached :logo
  has_one_attached :favicon

  normalizes :brand_primary_color, with: ->(value) { value.to_s.strip.presence }
  normalizes :brand_accent_color, with: ->(value) { value.to_s.strip.presence }

  normalizes :custom_domain, with: ->(value) {
    domain = value.to_s.strip.downcase
    domain = domain.sub(%r{\Ahttps?://}, "")
    domain = domain.split("/").first.to_s
    domain = domain.split(":").first.to_s
    domain.presence
  }

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/, message: "only allows lowercase letters, numbers, and hyphens" }
  validates :custom_domain, uniqueness: true, allow_nil: true,
    format: { with: DOMAIN_FORMAT, message: :invalid_domain, allow_blank: true }
  validates :subdomain, uniqueness: true, allow_nil: true,
    exclusion: { in: RESERVED_SUBDOMAINS, message: :reserved }
  validates :locale, presence: true
  validates :time_zone, presence: true
  validates :brand_primary_color, format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "must be a valid hex color (e.g., #1a73e8)" }, allow_blank: true
  validates :brand_accent_color, format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "must be a valid hex color (e.g., #1a73e8)" }, allow_blank: true
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  validate :logo_content_type_and_size
  validate :favicon_content_type_and_size

  LOGO_CONTENT_TYPES = %w[image/png image/jpeg image/svg+xml].freeze
  FAVICON_CONTENT_TYPES = %w[image/png image/x-icon image/svg+xml].freeze

  before_validation :set_subdomain_from_slug, on: :create

  private

  def set_subdomain_from_slug
    self.subdomain ||= slug if slug.present?
  end

  def logo_content_type_and_size
    return unless logo.attached?

    unless LOGO_CONTENT_TYPES.include?(logo.content_type)
      errors.add(:logo, "must be a PNG, JPEG, or SVG image")
    end

    if logo.byte_size > 2.megabytes
      errors.add(:logo, "must be less than 2MB")
    end
  end

  def favicon_content_type_and_size
    return unless favicon.attached?

    unless FAVICON_CONTENT_TYPES.include?(favicon.content_type)
      errors.add(:favicon, "must be a PNG, ICO, or SVG image")
    end

    if favicon.byte_size > 500.kilobytes
      errors.add(:favicon, "must be less than 500KB")
    end
  end
end
