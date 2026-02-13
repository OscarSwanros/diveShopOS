json.extract! certification, :id, :slug, :agency, :certification_level,
  :certification_number, :issued_date, :expiration_date, :notes
json.customer_id certification.customer_id
json.active certification.active?
json.expired certification.expired?
json.created_at certification.created_at.iso8601
json.updated_at certification.updated_at.iso8601
