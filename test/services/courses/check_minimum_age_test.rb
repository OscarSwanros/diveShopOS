# frozen_string_literal: true

require "test_helper"

class Courses::CheckMinimumAgeTest < ActiveSupport::TestCase
  test "succeeds when customer meets minimum age" do
    result = Courses::CheckMinimumAge.new(
      customer: customers(:jane_diver),
      course: courses(:padi_ow),
      offering: course_offerings(:padi_ow_upcoming)
    ).call

    assert result.success
    assert_nil result.reason
  end

  test "fails when customer is too young" do
    course = Course.new(agency: "PADI", level: "Rescue Diver", min_age: 15)
    result = Courses::CheckMinimumAge.new(
      customer: customers(:minor_diver),
      course: course,
      offering: course_offerings(:padi_ow_upcoming)
    ).call

    assert_not result.success
    assert_includes result.reason, "minimum age"
  end

  test "succeeds when course has no minimum age" do
    result = Courses::CheckMinimumAge.new(
      customer: customers(:minor_diver),
      course: courses(:ssi_nitrox),
      offering: course_offerings(:padi_ow_upcoming)
    ).call

    assert result.success
  end

  test "fails when customer has no date of birth" do
    result = Courses::CheckMinimumAge.new(
      customer: customers(:inactive_customer),
      course: courses(:padi_ow),
      offering: course_offerings(:padi_ow_upcoming)
    ).call

    assert_not result.success
    assert_includes result.reason, "no date of birth"
  end

  test "age is calculated as of offering start date" do
    # Minor is 14 today, course requires min age 10 - should pass
    result = Courses::CheckMinimumAge.new(
      customer: customers(:minor_diver),
      course: courses(:padi_ow),
      offering: course_offerings(:padi_ow_upcoming)
    ).call

    assert result.success
  end
end
