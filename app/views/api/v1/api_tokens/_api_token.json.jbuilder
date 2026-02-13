json.extract! api_token, :id, :name
json.last_used_at api_token.last_used_at&.iso8601
json.expires_at api_token.expires_at&.iso8601
json.revoked_at api_token.revoked_at&.iso8601
json.active api_token.active?
json.created_at api_token.created_at.iso8601
