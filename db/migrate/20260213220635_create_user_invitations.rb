# frozen_string_literal: true

class CreateUserInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :user_invitations, id: :string do |t|
      t.string :organization_id, null: false
      t.string :invited_by_id, null: false
      t.string :email, null: false
      t.string :name, null: false
      t.integer :role, default: 0, null: false
      t.string :token_digest, null: false
      t.datetime :accepted_at
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :user_invitations, :token_digest, unique: true
    add_index :user_invitations, [ :organization_id, :email ],
      unique: true,
      where: "accepted_at IS NULL",
      name: "index_user_invitations_on_org_email_pending"
    add_index :user_invitations, :organization_id
    add_index :user_invitations, :invited_by_id

    add_foreign_key :user_invitations, :organizations
    add_foreign_key :user_invitations, :users, column: :invited_by_id
  end
end
