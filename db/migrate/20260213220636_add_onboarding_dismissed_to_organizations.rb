# frozen_string_literal: true

class AddOnboardingDismissedToOrganizations < ActiveRecord::Migration[8.1]
  def change
    add_column :organizations, :onboarding_dismissed, :boolean, default: false, null: false
  end
end
