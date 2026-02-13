# frozen_string_literal: true

class ChecklistTemplate < ApplicationRecord
  include Sluggable

  belongs_to :organization

  slugged_by :title, scope: :organization_id

  has_many :checklist_items, dependent: :destroy
  has_many :checklist_runs, dependent: :restrict_with_error

  enum :category, { operational: 0, safety: 1, compliance: 2 }

  validates :title, presence: true, uniqueness: { scope: :organization_id }
  validates :category, presence: true

  scope :active, -> { where(active: true) }
  scope :by_category, ->(category) { where(category: category) }

  def items_ordered
    checklist_items.order(:position)
  end
end
