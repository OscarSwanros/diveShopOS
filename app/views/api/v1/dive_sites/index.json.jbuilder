json.data @dive_sites do |dive_site|
  json.partial! "api/v1/dive_sites/dive_site", dive_site: dive_site
end
json.partial! "api/v1/shared/pagination"
