# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[8.1]
  def change
    create_table :organizations, id: :string do |t|
      t.string :name, null: false
      t.string :slug, null: false

      # Whitelabel domain resolution
      t.string :custom_domain
      t.string :subdomain

      # Branding
      t.string :brand_primary_color
      t.string :brand_accent_color
      t.string :tagline

      # Localization & time zone
      t.string :locale, null: false, default: "en"
      t.string :time_zone, null: false, default: "UTC"

      t.timestamps
    end

    add_index :organizations, :slug, unique: true
    add_index :organizations, :custom_domain, unique: true
    add_index :organizations, :subdomain, unique: true
  end
end
