# frozen_string_literal: true

require "test_helper"

class InstructorRatingTest < ActiveSupport::TestCase
  test "valid instructor rating" do
    rating = instructor_ratings(:maria_padi_instructor)
    assert rating.valid?
  end

  test "requires agency" do
    rating = InstructorRating.new(
      user: users(:owner_maria),
      rating_level: "Instructor"
    )
    assert_not rating.valid?
    assert_includes rating.errors[:agency], "can't be blank"
  end

  test "requires rating_level" do
    rating = InstructorRating.new(
      user: users(:owner_maria),
      agency: "PADI"
    )
    assert_not rating.valid?
    assert_includes rating.errors[:rating_level], "can't be blank"
  end

  test "uniqueness of user+agency+rating_level" do
    rating = InstructorRating.new(
      user: users(:owner_maria),
      agency: "PADI",
      rating_level: "Open Water Instructor"
    )
    assert_not rating.valid?
    assert_includes rating.errors[:rating_level], "has already been taken"
  end

  test "active scope" do
    active = InstructorRating.active
    assert_includes active, instructor_ratings(:maria_padi_instructor)
    assert_not_includes active, instructor_ratings(:inactive_rating)
  end

  test "current scope excludes expired and inactive" do
    current = InstructorRating.current
    assert_includes current, instructor_ratings(:maria_padi_instructor)
    assert_not_includes current, instructor_ratings(:expired_rating)
    assert_not_includes current, instructor_ratings(:inactive_rating)
  end

  test "for_agency scope" do
    padi = InstructorRating.for_agency("PADI")
    assert_includes padi, instructor_ratings(:maria_padi_instructor)
    assert_not_includes padi, instructor_ratings(:carlos_ssi_instructor)
  end

  test "expired?" do
    assert instructor_ratings(:expired_rating).expired?
    assert_not instructor_ratings(:maria_padi_instructor).expired?
  end

  test "current?" do
    assert instructor_ratings(:maria_padi_instructor).current?
    assert_not instructor_ratings(:expired_rating).current?
    assert_not instructor_ratings(:inactive_rating).current?
  end

  test "generates UUID primary key" do
    rating = users(:owner_maria).instructor_ratings.create!(
      agency: "NAUI",
      rating_level: "Instructor"
    )
    assert_match(/\A[0-9a-f-]{36}\z/, rating.id)
  end
end
