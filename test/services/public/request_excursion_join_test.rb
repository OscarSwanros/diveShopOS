# frozen_string_literal: true

require "test_helper"

class Public::RequestExcursionJoinTest < ActiveSupport::TestCase
  setup do
    @excursion = excursions(:morning_reef)
    @bob = customers(:bob_bubbles)
  end

  test "creates trip participant with tp_requested status" do
    result = Public::RequestExcursionJoin.new(
      customer: @bob,
      excursion: @excursion
    ).call

    assert result.success
    assert_equal "tp_requested", result.trip_participant.status
    assert_equal @bob, result.trip_participant.customer
    assert_equal @bob.full_name, result.trip_participant.name
    assert_equal @bob.email, result.trip_participant.email
    assert_not_nil result.trip_participant.requested_at
  end

  test "stores safety gate results" do
    result = Public::RequestExcursionJoin.new(
      customer: @bob,
      excursion: @excursion
    ).call

    assert result.success
    assert result.trip_participant.safety_gate_results.present?
    assert result.trip_participant.safety_gate_results.key?("capacity")
  end

  test "rejects duplicate join request" do
    # First request
    Public::RequestExcursionJoin.new(
      customer: @bob,
      excursion: @excursion
    ).call

    # Try again
    result = Public::RequestExcursionJoin.new(
      customer: @bob,
      excursion: @excursion
    ).call

    assert_not result.success
    assert_includes result.error, I18n.t("public.join_requests.duplicate")
  end

  test "allows request when previous was cancelled" do
    tp = @excursion.trip_participants.create!(
      customer: @bob,
      name: @bob.full_name,
      email: @bob.email,
      role: :diver,
      status: :tp_cancelled,
      slug: "bob-cancelled-test"
    )

    result = Public::RequestExcursionJoin.new(
      customer: @bob,
      excursion: @excursion
    ).call

    assert result.success
  end
end
