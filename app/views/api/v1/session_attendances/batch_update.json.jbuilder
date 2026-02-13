json.data @attendances do |attendance|
  json.id attendance.id
  json.attended attendance.attended
  json.enrollment_id attendance.enrollment_id
  json.class_session_id attendance.class_session_id
  json.customer_name attendance.customer.full_name
end
