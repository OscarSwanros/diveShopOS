json.data @trip_participants do |participant|
  json.partial! "api/v1/trip_participants/trip_participant", trip_participant: participant
end
json.partial! "api/v1/shared/pagination"
