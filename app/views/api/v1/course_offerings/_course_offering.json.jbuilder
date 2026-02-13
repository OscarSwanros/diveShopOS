json.extract! course_offering, :id, :start_date, :end_date,
  :max_students, :price_cents, :price_currency, :status, :notes
json.course_id course_offering.course_id
json.instructor_id course_offering.instructor_id
json.instructor_name course_offering.instructor.name
json.spots_remaining course_offering.spots_remaining
json.effective_price_cents course_offering.effective_price_cents
json.created_at course_offering.created_at.iso8601
json.updated_at course_offering.updated_at.iso8601
