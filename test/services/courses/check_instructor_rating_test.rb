# frozen_string_literal: true

require "test_helper"

class Courses::CheckInstructorRatingTest < ActiveSupport::TestCase
  test "succeeds when instructor has current rating for agency" do
    result = Courses::CheckInstructorRating.new(
      instructor: users(:owner_maria),
      course: courses(:padi_ow)
    ).call

    assert result.success
    assert_nil result.reason
  end

  test "fails when instructor has no rating for agency" do
    result = Courses::CheckInstructorRating.new(
      instructor: users(:owner_maria),
      course: courses(:ssi_nitrox)
    ).call

    assert_not result.success
    assert_includes result.reason, "SSI"
  end

  test "fails when instructor rating is expired" do
    result = Courses::CheckInstructorRating.new(
      instructor: users(:manager_carlos),
      course: Course.new(agency: "DAN", level: "Test")
    ).call

    assert_not result.success
  end

  test "fails when instructor rating is inactive" do
    result = Courses::CheckInstructorRating.new(
      instructor: users(:staff_ana),
      course: courses(:padi_ow)
    ).call

    assert_not result.success
  end

  test "succeeds with matching SSI instructor" do
    result = Courses::CheckInstructorRating.new(
      instructor: users(:manager_carlos),
      course: courses(:ssi_nitrox)
    ).call

    assert result.success
  end
end
