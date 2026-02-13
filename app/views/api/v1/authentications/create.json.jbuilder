json.data do
  json.token @plain_token
  json.token_id @api_token.id
  json.name @api_token.name
  json.expires_at @api_token.expires_at&.iso8601
  json.user do
    json.id @api_token.user.id
    json.name @api_token.user.name
    json.email @api_token.user.email_address
    json.role @api_token.user.role
    json.organization_id @api_token.user.organization_id
  end
end
