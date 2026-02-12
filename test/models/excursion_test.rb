# frozen_string_literal: true

require "test_helper"

class ExcursionTest < ActiveSupport::TestCase
  test "valid excursion" do
    excursion = excursions(:morning_reef)
    assert excursion.valid?
  end

  test "requires title" do
    excursion = Excursion.new(
      organization: organizations(:reef_divers),
      scheduled_date: Date.current,
      capacity: 10
    )
    assert_not excursion.valid?
    assert_includes excursion.errors[:title], "can't be blank"
  end

  test "requires scheduled_date" do
    excursion = Excursion.new(
      organization: organizations(:reef_divers),
      title: "Test Trip",
      capacity: 10
    )
    assert_not excursion.valid?
    assert_includes excursion.errors[:scheduled_date], "can't be blank"
  end

  test "requires capacity" do
    excursion = Excursion.new(
      organization: organizations(:reef_divers),
      title: "Test Trip",
      scheduled_date: Date.current
    )
    assert_not excursion.valid?
    assert_includes excursion.errors[:capacity], "can't be blank"
  end

  test "capacity must be positive integer" do
    excursion = excursions(:morning_reef)

    excursion.capacity = 0
    assert_not excursion.valid?

    excursion.capacity = -1
    assert_not excursion.valid?

    excursion.capacity = 12
    assert excursion.valid?
  end

  test "price_cents must be non-negative" do
    excursion = excursions(:morning_reef)
    excursion.price_cents = -100
    assert_not excursion.valid?
    assert_includes excursion.errors[:price_cents], "must be greater than or equal to 0"
  end

  test "status enum" do
    assert excursions(:draft_trip).draft?
    assert excursions(:morning_reef).published?
    assert excursions(:past_trip).completed?
  end

  test "default status is draft" do
    excursion = Excursion.new
    assert excursion.draft?
  end

  test "upcoming scope" do
    upcoming = organizations(:reef_divers).excursions.upcoming
    assert_includes upcoming, excursions(:morning_reef)
    assert_includes upcoming, excursions(:draft_trip)
    assert_not_includes upcoming, excursions(:past_trip)
  end

  test "past scope" do
    past = organizations(:reef_divers).excursions.past
    assert_includes past, excursions(:past_trip)
    assert_not_includes past, excursions(:morning_reef)
  end

  test "by_status scope" do
    published = organizations(:reef_divers).excursions.by_status(:published)
    assert_includes published, excursions(:morning_reef)
    assert_not_includes published, excursions(:draft_trip)
  end

  test "spots_remaining" do
    excursion = excursions(:morning_reef)
    expected = excursion.capacity - excursion.trip_participants.count
    assert_equal expected, excursion.spots_remaining
  end

  test "full? returns true when at capacity" do
    excursion = excursions(:full_trip)
    assert excursion.full?
  end

  test "full? returns false when under capacity" do
    excursion = excursions(:morning_reef)
    assert_not excursion.full?
  end

  test "has many trip dives" do
    excursion = excursions(:morning_reef)
    assert_equal 2, excursion.trip_dives.count
  end

  test "has many trip participants" do
    excursion = excursions(:morning_reef)
    assert_equal 3, excursion.trip_participants.count
  end

  test "has many dive sites through trip dives" do
    excursion = excursions(:morning_reef)
    assert_includes excursion.dive_sites, dive_sites(:coral_garden)
    assert_includes excursion.dive_sites, dive_sites(:the_wall)
  end

  test "destroys trip dives when destroyed" do
    excursion = excursions(:morning_reef)
    dive_count = excursion.trip_dives.count
    assert_difference("TripDive.count", -dive_count) do
      excursion.destroy
    end
  end

  test "destroys trip participants when destroyed" do
    excursion = excursions(:morning_reef)
    participant_count = excursion.trip_participants.count
    assert_difference("TripParticipant.count", -participant_count) do
      excursion.destroy
    end
  end

  test "generates UUID primary key" do
    excursion = organizations(:reef_divers).excursions.create!(
      title: "New Trip",
      scheduled_date: Date.current + 30.days,
      capacity: 10
    )
    assert_match(/\A[0-9a-f-]{36}\z/, excursion.id)
  end
end
