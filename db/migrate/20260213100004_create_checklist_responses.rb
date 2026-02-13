# frozen_string_literal: true

class CreateChecklistResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :checklist_responses, id: :string do |t|
      t.references :checklist_run, null: false, foreign_key: true, type: :string
      t.references :checklist_item, null: false, foreign_key: true, type: :string
      t.references :completed_by, null: true, foreign_key: { to_table: :users }, type: :string
      t.boolean :checked, default: false, null: false
      t.datetime :checked_at
      t.boolean :auto_verified, default: false, null: false
      t.text :notes

      t.timestamps
    end

    add_index :checklist_responses, [ :checklist_run_id, :checklist_item_id ], unique: true, name: "index_checklist_responses_on_run_and_item"
    add_index :checklist_responses, [ :checklist_run_id, :checked ]
  end
end
