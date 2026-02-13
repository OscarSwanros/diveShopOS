class AddCustomerIdAndStatusToTripParticipants < ActiveRecord::Migration[8.1]
  def change
    add_reference :trip_participants, :customer, type: :string, foreign_key: true, null: true, index: true
    add_column :trip_participants, :status, :integer
    add_column :trip_participants, :requested_at, :datetime
    add_column :trip_participants, :declined_at, :datetime
    add_column :trip_participants, :declined_reason, :text
    add_column :trip_participants, :safety_gate_results, :text

    add_index :trip_participants, [ :excursion_id, :customer_id ], unique: true,
      where: "customer_id IS NOT NULL", name: "idx_trip_participants_excursion_customer_unique"
  end
end
