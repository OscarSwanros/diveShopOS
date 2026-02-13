class CreateCustomerAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :customer_accounts, id: :string do |t|
      t.references :organization, null: false, foreign_key: true, type: :string
      t.references :customer, null: false, foreign_key: true, type: :string, index: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.datetime :confirmed_at
      t.string :confirmation_token
      t.datetime :confirmation_sent_at
      t.datetime :last_sign_in_at
      t.string :last_sign_in_ip
      t.string :slug, null: false

      t.timestamps
    end

    add_index :customer_accounts, [ :organization_id, :email ], unique: true
    add_index :customer_accounts, :customer_id, unique: true
    add_index :customer_accounts, :confirmation_token, unique: true
    add_index :customer_accounts, [ :organization_id, :slug ], unique: true
  end
end
