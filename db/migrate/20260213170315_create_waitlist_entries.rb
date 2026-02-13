class CreateWaitlistEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :waitlist_entries, id: :string do |t|
      t.references :organization, null: false, foreign_key: true, type: :string
      t.references :customer, null: false, foreign_key: true, type: :string
      t.string :waitlistable_type, null: false
      t.string :waitlistable_id, null: false
      t.integer :position, null: false
      t.integer :status, null: false, default: 0
      t.datetime :notified_at
      t.datetime :expires_at
      t.string :slug, null: false

      t.timestamps
    end

    add_index :waitlist_entries, [ :waitlistable_type, :waitlistable_id, :position ], unique: true,
      name: "idx_waitlist_entries_on_waitlistable_and_position"
    add_index :waitlist_entries, [ :waitlistable_type, :waitlistable_id, :customer_id ], unique: true,
      where: "status = 0",
      name: "idx_waitlist_entries_on_waitlistable_and_customer"
    add_index :waitlist_entries, [ :organization_id, :slug ], unique: true
  end
end
