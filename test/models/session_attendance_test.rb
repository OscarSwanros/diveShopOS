# frozen_string_literal: true

require "test_helper"

class SessionAttendanceTest < ActiveSupport::TestCase
  test "valid session attendance" do
    attendance = session_attendances(:jane_classroom_1)
    assert attendance.valid?
  end

  test "requires class_session" do
    attendance = SessionAttendance.new(enrollment: enrollments(:jane_in_ow))
    assert_not attendance.valid?
    assert_includes attendance.errors[:class_session], "must exist"
  end

  test "requires enrollment" do
    attendance = SessionAttendance.new(class_session: class_sessions(:ow_classroom_1))
    assert_not attendance.valid?
    assert_includes attendance.errors[:enrollment], "must exist"
  end

  test "unique enrollment per class session" do
    duplicate = SessionAttendance.new(
      class_session: class_sessions(:ow_classroom_1),
      enrollment: enrollments(:jane_in_ow)
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:enrollment_id], "has already been taken"
  end

  test "attended defaults to false" do
    attendance = SessionAttendance.create!(
      class_session: class_sessions(:ow_open_water_1),
      enrollment: enrollments(:bob_in_ow)
    )
    assert_not attendance.attended?
  end

  test "delegates customer through enrollment" do
    attendance = session_attendances(:jane_classroom_1)
    assert_equal customers(:jane_diver), attendance.customer
  end

  test "generates UUID primary key" do
    attendance = SessionAttendance.create!(
      class_session: class_sessions(:ow_open_water_2),
      enrollment: enrollments(:bob_in_ow)
    )
    assert_match(/\A[0-9a-f-]{36}\z/, attendance.id)
  end
end
