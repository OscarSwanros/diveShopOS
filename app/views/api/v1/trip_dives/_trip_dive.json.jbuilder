json.extract! trip_dive, :id, :dive_number, :planned_max_depth_meters,
  :planned_bottom_time_minutes, :notes
json.excursion_id trip_dive.excursion_id
json.dive_site_id trip_dive.dive_site_id
json.dive_site_name trip_dive.dive_site.name
json.created_at trip_dive.created_at.iso8601
json.updated_at trip_dive.updated_at.iso8601
