# frozen_string_literal: true

require "test_helper"

class Api::V1::TripDivesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @excursion = excursions(:morning_reef)
    @trip_dive = trip_dives(:morning_dive_one)
  end

  test "index returns trip dives" do
    get api_v1_excursion_trip_dives_path(@excursion), headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
  end

  test "show returns trip dive with site name" do
    get api_v1_excursion_trip_dive_path(@excursion, @trip_dive), headers: api_headers(@token)

    assert_response :success
    assert_equal @trip_dive.id, parsed_response["data"]["id"]
    assert parsed_response["data"]["dive_site_name"].present?
  end

  test "create creates trip dive" do
    assert_difference "TripDive.count", 1 do
      post api_v1_excursion_trip_dives_path(@excursion), params: {
        trip_dive: {
          dive_site_id: dive_sites(:coral_garden).id, dive_number: 3,
          planned_max_depth_meters: 15, planned_bottom_time_minutes: 45
        }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "update updates trip dive" do
    patch api_v1_excursion_trip_dive_path(@excursion, @trip_dive), params: {
      trip_dive: { planned_bottom_time_minutes: 60 }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal 60, parsed_response["data"]["planned_bottom_time_minutes"]
  end

  test "destroy deletes trip dive" do
    delete api_v1_excursion_trip_dive_path(@excursion, @trip_dive), headers: api_headers(@token)
    assert_response :no_content
  end
end
