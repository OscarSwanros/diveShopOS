json.extract! course, :id, :slug, :name, :description, :agency, :level,
  :course_type, :min_age, :max_students, :duration_days,
  :price_cents, :price_currency, :prerequisites_description, :active
json.created_at course.created_at.iso8601
json.updated_at course.updated_at.iso8601
