json.extract! excursion, :id, :title, :description, :scheduled_date,
  :departure_time, :return_time, :capacity, :price_cents, :price_currency,
  :status, :notes
json.spots_remaining excursion.spots_remaining
json.created_at excursion.created_at.iso8601
json.updated_at excursion.updated_at.iso8601
