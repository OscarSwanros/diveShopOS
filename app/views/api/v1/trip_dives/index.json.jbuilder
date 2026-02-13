json.data @trip_dives do |trip_dive|
  json.partial! "api/v1/trip_dives/trip_dive", trip_dive: trip_dive
end
json.partial! "api/v1/shared/pagination"
