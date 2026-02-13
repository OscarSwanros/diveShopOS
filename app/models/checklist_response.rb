# frozen_string_literal: true

class ChecklistResponse < ApplicationRecord
  belongs_to :checklist_run
  belongs_to :checklist_item
  belongs_to :completed_by, class_name: "User", optional: true

  validates :checklist_item_id, uniqueness: { scope: :checklist_run_id }
end
