# frozen_string_literal: true

class EquipmentProfile < ApplicationRecord
  belongs_to :customer

  validates :customer_id, uniqueness: true
end
