# frozen_string_literal: true

require "test_helper"

class Api::V1::DiveSitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @dive_site = dive_sites(:coral_garden)
  end

  test "index returns dive sites with pagination" do
    get api_v1_dive_sites_path, headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
    assert parsed_response["meta"]["total_count"].positive?
  end

  test "index does not return other org sites" do
    get api_v1_dive_sites_path, headers: api_headers(@token)

    ids = parsed_response["data"].map { |s| s["id"] }
    refute_includes ids, dive_sites(:other_org_site).id
  end

  test "show returns dive site" do
    get api_v1_dive_site_path(@dive_site), headers: api_headers(@token)

    assert_response :success
    assert_equal @dive_site.id, parsed_response["data"]["id"]
    assert_equal "Coral Garden", parsed_response["data"]["name"]
  end

  test "create creates dive site" do
    assert_difference "DiveSite.count", 1 do
      post api_v1_dive_sites_path, params: {
        dive_site: { name: "New Site", difficulty_level: "beginner", max_depth_meters: 15 }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "create requires manager or owner" do
    staff_token = api_token_for(users(:staff_ana))
    post api_v1_dive_sites_path, params: {
      dive_site: { name: "Fail Site", difficulty_level: "beginner" }
    }, headers: api_headers(staff_token), as: :json

    assert_response :forbidden
  end

  test "update updates dive site" do
    patch api_v1_dive_site_path(@dive_site), params: {
      dive_site: { name: "Updated Garden" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "Updated Garden", parsed_response["data"]["name"]
  end

  test "destroy deletes dive site" do
    site = dive_sites(:inactive_site)
    delete api_v1_dive_site_path(site), headers: api_headers(@token)

    assert_response :no_content
  end
end
