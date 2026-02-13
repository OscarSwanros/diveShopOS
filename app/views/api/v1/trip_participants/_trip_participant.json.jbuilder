json.extract! trip_participant, :id, :slug, :name, :email, :phone,
  :certification_level, :certification_agency, :role, :notes, :paid
json.excursion_id trip_participant.excursion_id
json.created_at trip_participant.created_at.iso8601
json.updated_at trip_participant.updated_at.iso8601
