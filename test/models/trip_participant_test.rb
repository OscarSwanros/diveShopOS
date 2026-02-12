# frozen_string_literal: true

require "test_helper"

class TripParticipantTest < ActiveSupport::TestCase
  test "valid trip participant" do
    participant = trip_participants(:diver_jane)
    assert participant.valid?
  end

  test "requires name" do
    participant = TripParticipant.new(excursion: excursions(:morning_reef))
    assert_not participant.valid?
    assert_includes participant.errors[:name], "can't be blank"
  end

  test "validates email format when present" do
    participant = trip_participants(:diver_jane)
    participant.email = "not-an-email"
    assert_not participant.valid?
    assert_includes participant.errors[:email], "is invalid"
  end

  test "allows blank email" do
    participant = trip_participants(:guide_pedro)
    assert participant.valid?
  end

  test "role enum" do
    assert trip_participants(:diver_jane).diver?
    assert trip_participants(:guide_pedro).divemaster?
  end

  test "default role is diver" do
    participant = TripParticipant.new
    assert participant.diver?
  end

  test "belongs to excursion" do
    participant = trip_participants(:diver_jane)
    assert_equal excursions(:morning_reef), participant.excursion
  end

  test "delegates organization to excursion" do
    participant = trip_participants(:diver_jane)
    assert_equal organizations(:reef_divers), participant.organization
  end

  test "tracks paid status" do
    assert trip_participants(:diver_jane).paid?
    assert_not trip_participants(:diver_bob).paid?
  end

  test "generates UUID primary key" do
    participant = TripParticipant.create!(
      excursion: excursions(:draft_trip),
      name: "New Diver"
    )
    assert_match(/\A[0-9a-f-]{36}\z/, participant.id)
  end
end
