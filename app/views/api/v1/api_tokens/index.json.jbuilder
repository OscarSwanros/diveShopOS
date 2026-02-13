json.data @api_tokens do |token|
  json.partial! "api/v1/api_tokens/api_token", api_token: token
end
