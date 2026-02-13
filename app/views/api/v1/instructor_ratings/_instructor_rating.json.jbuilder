json.extract! instructor_rating, :id, :slug, :agency, :rating_level, :rating_number,
  :active, :expiration_date
json.user_id instructor_rating.user_id
json.user_name instructor_rating.user.name
json.current instructor_rating.current?
json.created_at instructor_rating.created_at.iso8601
json.updated_at instructor_rating.updated_at.iso8601
