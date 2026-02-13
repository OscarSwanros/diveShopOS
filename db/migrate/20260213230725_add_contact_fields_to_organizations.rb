class AddContactFieldsToOrganizations < ActiveRecord::Migration[8.1]
  def change
    add_column :organizations, :phone, :string
    add_column :organizations, :contact_email, :string
    add_column :organizations, :address, :text
    add_column :organizations, :social_links, :jsonb, default: {}
  end
end
