json.data @class_sessions do |session|
  json.partial! "api/v1/class_sessions/class_session", class_session: session
end
json.partial! "api/v1/shared/pagination"
