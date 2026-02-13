# frozen_string_literal: true

require "test_helper"

class Public::RequestEnrollmentTest < ActiveSupport::TestCase
  setup do
    @offering = course_offerings(:padi_ow_upcoming)
    @bob = customers(:bob_bubbles)
    # Remove Bob's existing enrollment for clean test
    @bob.enrollments.where(course_offering: @offering).destroy_all
  end

  test "creates enrollment with requested status" do
    result = Public::RequestEnrollment.new(
      customer: @bob,
      course_offering: @offering
    ).call

    assert result.success
    assert_equal "requested", result.enrollment.status
    assert_not_nil result.enrollment.requested_at
    assert_equal @bob, result.enrollment.customer
  end

  test "stores safety gate results" do
    result = Public::RequestEnrollment.new(
      customer: @bob,
      course_offering: @offering
    ).call

    assert result.success
    assert result.enrollment.safety_gate_results.present?
    assert result.enrollment.safety_gate_results.key?("student_ratio")
    assert result.enrollment.safety_gate_results.key?("medical_clearance")
  end

  test "checks minimum age when course has min_age" do
    result = Public::RequestEnrollment.new(
      customer: @bob,
      course_offering: @offering
    ).call

    assert result.success
    assert result.enrollment.safety_gate_results.key?("minimum_age")
  end

  test "rejects duplicate enrollment" do
    # Create initial enrollment
    Public::RequestEnrollment.new(
      customer: @bob,
      course_offering: @offering
    ).call

    # Try again
    result = Public::RequestEnrollment.new(
      customer: @bob,
      course_offering: @offering
    ).call

    assert_not result.success
    assert_includes result.error, I18n.t("public.enrollment_requests.duplicate")
  end

  test "allows request when previous enrollment was withdrawn" do
    @offering.enrollments.create!(
      customer: @bob,
      status: :withdrawn,
      slug: "bob-withdrawn-test"
    )

    result = Public::RequestEnrollment.new(
      customer: @bob,
      course_offering: @offering
    ).call

    assert result.success
  end
end
