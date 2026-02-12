# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[8.1]
  def change
    create_table :customers, id: :string do |t|
      t.references :organization, null: false, foreign_key: true, type: :string
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email
      t.string :phone
      t.date :date_of_birth
      t.string :emergency_contact_name
      t.string :emergency_contact_phone
      t.text :notes
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :customers, [ :organization_id, :last_name, :first_name ], name: "index_customers_on_org_and_name"
    add_index :customers, [ :organization_id, :active ], name: "index_customers_on_org_and_active"
    add_index :customers, [ :organization_id, :email ], unique: true,
      where: "email IS NOT NULL", name: "index_customers_on_org_and_email"
  end
end
