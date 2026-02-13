json.data do
  json.partial! "api/v1/trip_participants/trip_participant", trip_participant: @trip_participant
end
