json.data @instructor_ratings do |rating|
  json.partial! "api/v1/instructor_ratings/instructor_rating", instructor_rating: rating
end
json.partial! "api/v1/shared/pagination"
