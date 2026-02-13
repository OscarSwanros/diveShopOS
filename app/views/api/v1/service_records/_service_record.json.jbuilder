json.extract! service_record, :id, :service_type, :service_date, :next_due_date,
  :performed_by, :cost_cents, :cost_currency, :description, :notes
json.equipment_item_id service_record.equipment_item_id
json.created_at service_record.created_at.iso8601
json.updated_at service_record.updated_at.iso8601
