# frozen_string_literal: true

require "test_helper"

class TripDiveTest < ActiveSupport::TestCase
  test "valid trip dive" do
    dive = trip_dives(:morning_dive_one)
    assert dive.valid?
  end

  test "requires dive_number" do
    dive = TripDive.new(
      excursion: excursions(:morning_reef),
      dive_site: dive_sites(:coral_garden)
    )
    assert_not dive.valid?
    assert_includes dive.errors[:dive_number], "can't be blank"
  end

  test "dive_number must be positive" do
    dive = trip_dives(:morning_dive_one)
    dive.dive_number = 0
    assert_not dive.valid?

    dive.dive_number = -1
    assert_not dive.valid?
  end

  test "dive_number must be unique within excursion" do
    dive = TripDive.new(
      excursion: excursions(:morning_reef),
      dive_site: dive_sites(:coral_garden),
      dive_number: 1
    )
    assert_not dive.valid?
    assert_includes dive.errors[:dive_number], "has already been taken"
  end

  test "same dive_number allowed in different excursions" do
    dive = TripDive.new(
      excursion: excursions(:draft_trip),
      dive_site: dive_sites(:coral_garden),
      dive_number: 1
    )
    assert dive.valid?
  end

  test "validates planned_max_depth_meters is positive" do
    dive = trip_dives(:morning_dive_one)
    dive.planned_max_depth_meters = -10
    assert_not dive.valid?
  end

  test "validates planned_bottom_time_minutes is positive" do
    dive = trip_dives(:morning_dive_one)
    dive.planned_bottom_time_minutes = 0
    assert_not dive.valid?
  end

  test "belongs to excursion" do
    dive = trip_dives(:morning_dive_one)
    assert_equal excursions(:morning_reef), dive.excursion
  end

  test "belongs to dive site" do
    dive = trip_dives(:morning_dive_one)
    assert_equal dive_sites(:coral_garden), dive.dive_site
  end

  test "delegates organization to excursion" do
    dive = trip_dives(:morning_dive_one)
    assert_equal organizations(:reef_divers), dive.organization
  end

  test "generates UUID primary key" do
    dive = TripDive.create!(
      excursion: excursions(:draft_trip),
      dive_site: dive_sites(:coral_garden),
      dive_number: 1
    )
    assert_match(/\A[0-9a-f-]{36}\z/, dive.id)
  end
end
