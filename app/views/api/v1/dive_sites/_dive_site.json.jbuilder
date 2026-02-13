json.extract! dive_site, :id, :slug, :name, :description, :difficulty_level,
  :max_depth_meters, :latitude, :longitude, :location_description, :active
json.created_at dive_site.created_at.iso8601
json.updated_at dive_site.updated_at.iso8601
