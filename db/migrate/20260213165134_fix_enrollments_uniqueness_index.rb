class FixEnrollmentsUniquenessIndex < ActiveRecord::Migration[8.1]
  def change
    remove_index :enrollments, name: "index_enrollments_on_course_offering_id_and_customer_id"
    add_index :enrollments, [ :course_offering_id, :customer_id ], unique: true,
      where: "status NOT IN (4, 5, 7)",
      name: "index_enrollments_on_course_offering_id_and_customer_id"
  end
end
