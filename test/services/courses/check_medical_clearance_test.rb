# frozen_string_literal: true

require "test_helper"

class Courses::CheckMedicalClearanceTest < ActiveSupport::TestCase
  test "succeeds when customer has valid clearance and offering has water sessions" do
    result = Courses::CheckMedicalClearance.new(
      customer: customers(:jane_diver),
      course_offering: course_offerings(:padi_ow_upcoming)
    ).call

    assert result.success
    assert_nil result.reason
  end

  test "fails when customer has no valid clearance and offering has water sessions" do
    result = Courses::CheckMedicalClearance.new(
      customer: customers(:bob_bubbles),
      course_offering: course_offerings(:padi_ow_upcoming)
    ).call

    assert_not result.success
    assert_includes result.reason, "medical clearance"
  end

  test "succeeds when offering has no water sessions" do
    # Create an offering with only classroom sessions
    offering = course_offerings(:padi_aow_draft)
    # This offering has no sessions at all, so no water sessions
    result = Courses::CheckMedicalClearance.new(
      customer: customers(:bob_bubbles),
      course_offering: offering
    ).call

    assert result.success
  end

  test "succeeds for customer without clearance when no water sessions exist" do
    offering = course_offerings(:padi_aow_draft)
    result = Courses::CheckMedicalClearance.new(
      customer: customers(:minor_diver),
      course_offering: offering
    ).call

    assert result.success
  end
end
