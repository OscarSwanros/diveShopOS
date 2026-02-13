class AddRequestedAndDeclinedToEnrollments < ActiveRecord::Migration[8.1]
  def change
    add_column :enrollments, :requested_at, :datetime
    add_column :enrollments, :declined_at, :datetime
    add_column :enrollments, :declined_reason, :text
    add_column :enrollments, :safety_gate_results, :text

    add_index :enrollments, [ :course_offering_id, :status ], if_not_exists: true
  end
end
