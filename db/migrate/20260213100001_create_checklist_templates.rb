# frozen_string_literal: true

class CreateChecklistTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :checklist_templates, id: :string do |t|
      t.references :organization, null: false, foreign_key: true, type: :string
      t.string :title, null: false
      t.text :description
      t.integer :category, null: false
      t.boolean :active, default: true, null: false
      t.string :slug, null: false

      t.timestamps
    end

    add_index :checklist_templates, [ :organization_id, :category ]
    add_index :checklist_templates, [ :organization_id, :active ]
    add_index :checklist_templates, [ :organization_id, :slug ], unique: true
    add_index :checklist_templates, [ :organization_id, :title ], unique: true
  end
end
