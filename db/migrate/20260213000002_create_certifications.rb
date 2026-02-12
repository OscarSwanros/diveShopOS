# frozen_string_literal: true

class CreateCertifications < ActiveRecord::Migration[8.1]
  def change
    create_table :certifications, id: :string do |t|
      t.references :customer, null: false, foreign_key: true, type: :string
      t.string :agency, null: false
      t.string :certification_level, null: false
      t.string :certification_number
      t.date :issued_date
      t.date :expiration_date
      t.references :issuing_organization, foreign_key: { to_table: :organizations }, type: :string
      t.text :notes
      t.datetime :discarded_at

      t.timestamps
    end

    add_index :certifications, :discarded_at
    add_index :certifications, [ :customer_id, :agency, :certification_level ], name: "index_certs_on_customer_agency_level"
  end
end
