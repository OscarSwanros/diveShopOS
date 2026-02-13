json.extract! equipment_item, :id, :category, :name, :serial_number, :size,
  :manufacturer, :product_model, :status, :life_support,
  :purchase_date, :last_service_date, :next_service_due, :notes
json.organization_id equipment_item.organization_id
json.service_current equipment_item.service_current?
json.service_overdue equipment_item.service_overdue?
json.created_at equipment_item.created_at.iso8601
json.updated_at equipment_item.updated_at.iso8601
