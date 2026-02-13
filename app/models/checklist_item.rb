# frozen_string_literal: true

class ChecklistItem < ApplicationRecord
  include Sluggable

  belongs_to :checklist_template

  slugged_by :title, scope: :checklist_template_id

  has_many :checklist_responses, dependent: :destroy

  validates :title, presence: true
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  scope :ordered, -> { order(:position) }
  scope :required_items, -> { where(required: true) }
end
