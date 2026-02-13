# frozen_string_literal: true

require "test_helper"

class Api::V1::ExcursionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @excursion = excursions(:morning_reef)
  end

  test "index returns excursions with pagination" do
    get api_v1_excursions_path, headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
    assert parsed_response["meta"]["total_count"].positive?
  end

  test "index filters by status" do
    get api_v1_excursions_path(status: "published"), headers: api_headers(@token)

    assert_response :success
    parsed_response["data"].each do |exc|
      assert_equal "published", exc["status"]
    end
  end

  test "index does not return other org excursions" do
    get api_v1_excursions_path, headers: api_headers(@token)

    ids = parsed_response["data"].map { |e| e["id"] }
    refute_includes ids, excursions(:other_org_excursion).id
  end

  test "show returns excursion with spots remaining" do
    get api_v1_excursion_path(@excursion), headers: api_headers(@token)

    assert_response :success
    assert_equal @excursion.id, parsed_response["data"]["id"]
    assert parsed_response["data"].key?("spots_remaining")
  end

  test "create creates excursion" do
    assert_difference "Excursion.count", 1 do
      post api_v1_excursions_path, params: {
        excursion: {
          title: "New Trip", scheduled_date: Date.current + 30.days,
          capacity: 10, price_cents: 15000, status: "draft"
        }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "update updates excursion" do
    patch api_v1_excursion_path(@excursion), params: {
      excursion: { title: "Updated Trip" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "Updated Trip", parsed_response["data"]["title"]
  end

  test "destroy deletes excursion" do
    delete api_v1_excursion_path(excursions(:draft_trip)), headers: api_headers(@token)
    assert_response :no_content
  end

  test "destroy requires manager or owner" do
    staff_token = api_token_for(users(:staff_ana))
    delete api_v1_excursion_path(@excursion), headers: api_headers(staff_token)

    assert_response :forbidden
  end
end
