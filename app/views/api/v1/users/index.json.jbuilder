json.data @users do |user|
  json.partial! "api/v1/users/user", user: user
end
json.partial! "api/v1/shared/pagination"
