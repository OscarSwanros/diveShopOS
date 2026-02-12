# frozen_string_literal: true

require "test_helper"

class Courses::ValidateCompletionTest < ActiveSupport::TestCase
  test "succeeds when all sessions are attended" do
    result = Courses::ValidateCompletion.new(
      enrollment: enrollments(:jane_in_ow)
    ).call

    assert result.success
    assert_nil result.reason
  end

  test "fails when sessions are missing attendance" do
    result = Courses::ValidateCompletion.new(
      enrollment: enrollments(:bob_in_ow)
    ).call

    assert_not result.success
    assert_includes result.reason, "session"
  end

  test "succeeds when offering has no sessions" do
    offering = CourseOffering.create!(
      course: courses(:ssi_nitrox),
      organization: organizations(:reef_divers),
      instructor: users(:manager_carlos),
      start_date: Date.current + 30.days,
      max_students: 6
    )
    enrollment = Enrollment.create!(
      course_offering: offering,
      customer: customers(:jane_diver),
      status: :confirmed,
      enrolled_at: Time.current
    )

    result = Courses::ValidateCompletion.new(enrollment: enrollment).call

    assert result.success
  end

  test "counts unattended sessions correctly" do
    # Bob has 2 attendance records: classroom_1 (attended:true), confined_1 (attended:false)
    # Missing: ow_open_water_1, ow_open_water_2
    # So 3 sessions are not attended (confined_1 false + 2 missing)
    result = Courses::ValidateCompletion.new(
      enrollment: enrollments(:bob_in_ow)
    ).call

    assert_not result.success
    assert_includes result.reason, "3"
  end
end
