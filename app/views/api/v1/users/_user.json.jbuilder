json.extract! user, :id, :slug, :name, :email_address, :role
json.created_at user.created_at.iso8601
json.updated_at user.updated_at.iso8601
