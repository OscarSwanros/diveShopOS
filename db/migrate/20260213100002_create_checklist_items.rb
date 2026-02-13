# frozen_string_literal: true

class CreateChecklistItems < ActiveRecord::Migration[8.1]
  def change
    create_table :checklist_items, id: :string do |t|
      t.references :checklist_template, null: false, foreign_key: true, type: :string
      t.string :title, null: false
      t.text :description
      t.integer :position, null: false
      t.boolean :required, default: true, null: false
      t.string :auto_check_key
      t.string :slug, null: false

      t.timestamps
    end

    add_index :checklist_items, [ :checklist_template_id, :position ]
    add_index :checklist_items, [ :checklist_template_id, :slug ], unique: true
  end
end
