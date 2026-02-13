json.data @equipment_items do |equipment_item|
  json.partial! "api/v1/equipment_items/equipment_item", equipment_item: equipment_item
end
json.partial! "api/v1/shared/pagination"
