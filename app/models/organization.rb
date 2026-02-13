# frozen_string_literal: true

class Organization < ApplicationRecord
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

  has_one_attached :logo
  has_one_attached :favicon

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/, message: "only allows lowercase letters, numbers, and hyphens" }
  validates :custom_domain, uniqueness: true, allow_nil: true
  validates :subdomain, uniqueness: true, allow_nil: true
  validates :locale, presence: true
  validates :time_zone, presence: true
end
