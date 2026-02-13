json.data @enrollments do |enrollment|
  json.partial! "api/v1/enrollments/enrollment", enrollment: enrollment
end
json.partial! "api/v1/shared/pagination"
