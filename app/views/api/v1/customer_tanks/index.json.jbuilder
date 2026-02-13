json.data @customer_tanks do |customer_tank|
  json.partial! "api/v1/customer_tanks/customer_tank", customer_tank: customer_tank
end
json.partial! "api/v1/shared/pagination"
