# frozen_string_literal: true

class CreateChecklistRuns < ActiveRecord::Migration[8.1]
  def change
    create_table :checklist_runs, id: :string do |t|
      t.references :organization, null: false, foreign_key: true, type: :string
      t.references :checklist_template, null: false, foreign_key: true, type: :string
      t.references :started_by, null: false, foreign_key: { to_table: :users }, type: :string
      t.string :checkable_type
      t.string :checkable_id
      t.integer :status, null: false, default: 0
      t.datetime :completed_at
      t.text :notes
      t.json :template_snapshot
      t.string :slug, null: false

      t.timestamps
    end

    add_index :checklist_runs, [ :organization_id, :status ]
    add_index :checklist_runs, [ :organization_id, :checklist_template_id ], name: "index_checklist_runs_on_org_and_template"
    add_index :checklist_runs, [ :checkable_type, :checkable_id ]
    add_index :checklist_runs, [ :organization_id, :slug ], unique: true
  end
end
