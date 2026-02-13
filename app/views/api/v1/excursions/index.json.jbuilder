json.data @excursions do |excursion|
  json.partial! "api/v1/excursions/excursion", excursion: excursion
end
json.partial! "api/v1/shared/pagination"
