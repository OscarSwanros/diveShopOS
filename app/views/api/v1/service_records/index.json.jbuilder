json.data @service_records do |service_record|
  json.partial! "api/v1/service_records/service_record", service_record: service_record
end
json.partial! "api/v1/shared/pagination"
