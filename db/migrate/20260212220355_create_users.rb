# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :string do |t|
      t.references :organization, null: false, foreign_key: true, type: :string
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.string :name, null: false
      t.integer :role, null: false, default: 0

      t.timestamps
    end

    add_index :users, [ :organization_id, :email_address ], unique: true
  end
end
