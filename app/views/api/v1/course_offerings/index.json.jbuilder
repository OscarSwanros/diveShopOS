json.data @course_offerings do |offering|
  json.partial! "api/v1/course_offerings/course_offering", course_offering: offering
end
json.partial! "api/v1/shared/pagination"
