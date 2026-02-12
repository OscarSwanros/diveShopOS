# frozen_string_literal: true

require "test_helper"

class Courses::CheckStudentRatioTest < ActiveSupport::TestCase
  test "succeeds when offering has spots remaining" do
    result = Courses::CheckStudentRatio.new(
      course_offering: course_offerings(:padi_ow_upcoming)
    ).call

    assert result.success
    assert_nil result.reason
  end

  test "fails when offering is at capacity" do
    result = Courses::CheckStudentRatio.new(
      course_offering: course_offerings(:padi_ow_full)
    ).call

    assert_not result.success
    assert_includes result.reason, "at capacity"
  end

  test "excludes withdrawn from count" do
    offering = course_offerings(:padi_ow_upcoming)
    # Has 2 countable + 1 withdrawn, max 8 = should succeed
    result = Courses::CheckStudentRatio.new(course_offering: offering).call

    assert result.success
  end

  test "fails message includes counts" do
    result = Courses::CheckStudentRatio.new(
      course_offering: course_offerings(:padi_ow_full)
    ).call

    assert_includes result.reason, "2"
  end
end
