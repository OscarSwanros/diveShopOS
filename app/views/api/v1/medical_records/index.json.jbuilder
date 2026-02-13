json.data @medical_records do |medical_record|
  json.partial! "api/v1/medical_records/medical_record", medical_record: medical_record
end
json.partial! "api/v1/shared/pagination"
