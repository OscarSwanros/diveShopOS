json.extract! enrollment, :id, :status, :paid, :notes,
  :enrolled_at, :completed_at
json.course_offering_id enrollment.course_offering_id
json.customer_id enrollment.customer_id
json.customer_name enrollment.customer.full_name
json.certification_id enrollment.certification_id
json.created_at enrollment.created_at.iso8601
json.updated_at enrollment.updated_at.iso8601
