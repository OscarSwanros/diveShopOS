# frozen_string_literal: true

class RenameEquipmentModelName < ActiveRecord::Migration[8.1]
  def change
    rename_column :equipment_items, :model_name, :product_model
  end
end
