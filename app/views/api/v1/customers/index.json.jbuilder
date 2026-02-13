json.data @customers do |customer|
  json.partial! "api/v1/customers/customer", customer: customer
end
json.partial! "api/v1/shared/pagination"
