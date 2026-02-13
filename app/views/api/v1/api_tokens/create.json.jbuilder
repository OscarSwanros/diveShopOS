json.data do
  json.partial! "api/v1/api_tokens/api_token", api_token: @api_token
  json.token @plain_token
end
