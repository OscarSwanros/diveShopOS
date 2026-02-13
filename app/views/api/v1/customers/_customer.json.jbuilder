json.extract! customer, :id, :slug, :first_name, :last_name, :email, :phone,
  :date_of_birth, :emergency_contact_name, :emergency_contact_phone,
  :notes, :active
json.full_name customer.full_name
json.created_at customer.created_at.iso8601
json.updated_at customer.updated_at.iso8601
