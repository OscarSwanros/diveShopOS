class FixTripParticipantsUniquenessIndex < ActiveRecord::Migration[8.1]
  def change
    remove_index :trip_participants, name: "idx_trip_participants_excursion_customer_unique"
    add_index :trip_participants, [ :excursion_id, :customer_id ], unique: true,
      where: "customer_id IS NOT NULL AND status != 2",
      name: "idx_trip_participants_excursion_customer_unique"
  end
end
