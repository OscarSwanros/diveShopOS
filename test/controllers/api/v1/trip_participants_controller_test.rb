# frozen_string_literal: true

require "test_helper"

class Api::V1::TripParticipantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @excursion = excursions(:morning_reef)
    @participant = trip_participants(:diver_jane)
  end

  test "index returns participants" do
    get api_v1_excursion_trip_participants_path(@excursion), headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
  end

  test "show returns participant" do
    get api_v1_excursion_trip_participant_path(@excursion, @participant), headers: api_headers(@token)

    assert_response :success
    assert_equal @participant.id, parsed_response["data"]["id"]
  end

  test "create creates participant" do
    assert_difference "TripParticipant.count", 1 do
      post api_v1_excursion_trip_participants_path(@excursion), params: {
        trip_participant: { name: "New Diver", role: "diver" }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "create enforces capacity gate" do
    full_trip = excursions(:full_trip)

    post api_v1_excursion_trip_participants_path(full_trip), params: {
      trip_participant: { name: "Over Capacity", role: "diver" }
    }, headers: api_headers(@token), as: :json

    assert_response :unprocessable_entity
    assert_equal "safety_gate_failed", parsed_response["error"]["code"]
  end

  test "update updates participant" do
    patch api_v1_excursion_trip_participant_path(@excursion, @participant), params: {
      trip_participant: { paid: true }
    }, headers: api_headers(@token), as: :json

    assert_response :success
  end

  test "destroy deletes participant" do
    delete api_v1_excursion_trip_participant_path(@excursion, @participant), headers: api_headers(@token)
    assert_response :no_content
  end
end
