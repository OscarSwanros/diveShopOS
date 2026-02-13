json.data @courses do |course|
  json.partial! "api/v1/courses/course", course: course
end
json.partial! "api/v1/shared/pagination"
