json.meta do
  json.current_page @pagination[:current_page]
  json.per_page @pagination[:per_page]
  json.total_count @pagination[:total_count]
  json.total_pages @pagination[:total_pages]
end
