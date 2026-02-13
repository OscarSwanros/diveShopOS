json.extract! medical_record, :id, :status, :clearance_date,
  :expiration_date, :physician_name, :notes
json.customer_id medical_record.customer_id
json.valid_clearance medical_record.valid_clearance?
json.created_at medical_record.created_at.iso8601
json.updated_at medical_record.updated_at.iso8601
