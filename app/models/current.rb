# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :organization, :user, :customer_account
end
