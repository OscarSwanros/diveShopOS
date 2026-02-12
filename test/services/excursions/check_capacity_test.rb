# frozen_string_literal: true

require "test_helper"

class Excursions::CheckCapacityTest < ActiveSupport::TestCase
  test "succeeds when excursion has spots remaining" do
    excursion = excursions(:morning_reef)
    result = Excursions::CheckCapacity.new(excursion: excursion).call

    assert result.success
    assert_nil result.reason
  end

  test "fails when excursion is at capacity" do
    excursion = excursions(:full_trip)
    result = Excursions::CheckCapacity.new(excursion: excursion).call

    assert_not result.success
    assert_includes result.reason, "at capacity"
  end

  test "fails when excursion is over capacity" do
    excursion = excursions(:full_trip)
    # Add one more to go over
    excursion.trip_participants.create!(name: "Extra Diver")
    result = Excursions::CheckCapacity.new(excursion: excursion).call

    assert_not result.success
    assert_includes result.reason, "at capacity"
  end

  test "succeeds for excursion with no participants" do
    excursion = excursions(:draft_trip)
    result = Excursions::CheckCapacity.new(excursion: excursion).call

    assert result.success
    assert_nil result.reason
  end

  test "result includes capacity details in failure message" do
    excursion = excursions(:full_trip)
    result = Excursions::CheckCapacity.new(excursion: excursion).call

    assert_includes result.reason, excursion.capacity.to_s
  end
end
