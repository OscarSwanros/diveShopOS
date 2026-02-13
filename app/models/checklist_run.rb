# frozen_string_literal: true

class ChecklistRun < ApplicationRecord
  include Sluggable

  belongs_to :organization
  belongs_to :checklist_template
  belongs_to :started_by, class_name: "User"
  belongs_to :checkable, polymorphic: true, optional: true

  slugged_by -> { "#{checklist_template&.title} #{created_at&.strftime('%b-%d-%Y-%H%M')}" }, scope: :organization_id

  has_many :checklist_responses, dependent: :destroy

  enum :status, { in_progress: 0, completed: 1, completed_with_exceptions: 2, abandoned: 3 }

  validates :status, presence: true

  scope :active, -> { where(status: :in_progress) }
  scope :finished, -> { where(status: [ :completed, :completed_with_exceptions ]) }

  def progress
    total = checklist_responses.count
    return { checked: 0, total: 0, percentage: 0 } if total.zero?

    checked = checklist_responses.where(checked: true).count
    { checked: checked, total: total, percentage: (checked.to_f / total * 100).round }
  end

  def all_required_checked?
    checklist_responses
      .joins(:checklist_item)
      .where(checklist_items: { required: true })
      .where(checked: false)
      .none?
  end
end
