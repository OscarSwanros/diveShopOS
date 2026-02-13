json.extract! class_session, :id, :session_type, :title,
  :scheduled_date, :start_time, :end_time,
  :location_description, :notes
json.course_offering_id class_session.course_offering_id
json.dive_site_id class_session.dive_site_id
json.water_session class_session.water_session?
json.created_at class_session.created_at.iso8601
json.updated_at class_session.updated_at.iso8601
