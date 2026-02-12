# frozen_string_literal: true

require "test_helper"

class EnrollmentTest < ActiveSupport::TestCase
  test "valid enrollment" do
    enrollment = enrollments(:jane_in_ow)
    assert enrollment.valid?
  end

  test "unique customer per offering" do
    enrollment = Enrollment.new(
      course_offering: course_offerings(:padi_ow_upcoming),
      customer: customers(:jane_diver)
    )
    assert_not enrollment.valid?
    assert_includes enrollment.errors[:customer_id], "has already been taken"
  end

  test "status enum" do
    assert enrollments(:bob_in_ow).pending?
    assert enrollments(:jane_in_ow).confirmed?
    assert enrollments(:withdrawn_enrollment).withdrawn?
  end

  test "countable scope excludes withdrawn and failed" do
    countable = course_offerings(:padi_ow_upcoming).enrollments.countable
    assert_includes countable, enrollments(:jane_in_ow)
    assert_includes countable, enrollments(:bob_in_ow)
    assert_not_includes countable, enrollments(:withdrawn_enrollment)
  end

  test "active_enrollments scope" do
    active = course_offerings(:padi_ow_upcoming).enrollments.active_enrollments
    assert_includes active, enrollments(:jane_in_ow)
    assert_includes active, enrollments(:bob_in_ow)
    assert_not_includes active, enrollments(:withdrawn_enrollment)
  end

  test "complete! updates status and timestamp" do
    enrollment = enrollments(:jane_in_ow)
    enrollment.complete!
    assert enrollment.completed?
    assert_not_nil enrollment.completed_at
  end

  test "complete! with certification" do
    enrollment = enrollments(:jane_in_ow)
    cert = certifications(:jane_ow)
    enrollment.complete!(certification: cert)
    assert_equal cert, enrollment.certification
  end

  test "withdraw!" do
    enrollment = enrollments(:bob_in_ow)
    enrollment.withdraw!
    assert enrollment.withdrawn?
  end

  test "spots_remaining on offering with enrollments" do
    offering = course_offerings(:padi_ow_upcoming)
    countable = offering.enrollments.countable.count
    assert_equal offering.max_students - countable, offering.spots_remaining
  end

  test "full? returns true when at capacity" do
    offering = course_offerings(:padi_ow_full)
    assert offering.full?
  end

  test "full? returns false when spots available" do
    offering = course_offerings(:padi_ow_upcoming)
    assert_not offering.full?
  end

  test "generates UUID primary key" do
    enrollment = Enrollment.create!(
      course_offering: course_offerings(:padi_aow_draft),
      customer: customers(:jane_diver),
      enrolled_at: Time.current
    )
    assert_match(/\A[0-9a-f-]{36}\z/, enrollment.id)
  end
end
