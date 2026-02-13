json.extract! equipment_profile, :id, :height_cm, :weight_kg,
  :wetsuit_size, :wetsuit_thickness_mm, :bcd_size, :boot_size,
  :fin_size, :glove_size, :owns_mask, :owns_computer, :owns_wetsuit,
  :owns_fins, :owns_bcd, :owns_regulator, :notes
json.customer_id equipment_profile.customer_id
json.created_at equipment_profile.created_at.iso8601
json.updated_at equipment_profile.updated_at.iso8601
