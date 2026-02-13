# frozen_string_literal: true

require "test_helper"

class Api::V1::EquipmentProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @customer = customers(:jane_diver)
    @profile = equipment_profiles(:jane_profile)
  end

  test "show returns equipment profile" do
    get api_v1_customer_equipment_profile_path(@customer), headers: api_headers(@token)

    assert_response :success
    assert_equal @profile.id, parsed_response["data"]["id"]
  end

  test "show returns 404 when no profile exists" do
    customer = customers(:bob_bubbles)
    get api_v1_customer_equipment_profile_path(customer), headers: api_headers(@token)

    assert_response :not_found
  end

  test "create creates equipment profile" do
    customer = customers(:bob_bubbles)

    post api_v1_customer_equipment_profile_path(customer), params: {
      equipment_profile: { wetsuit_size: "L", bcd_size: "L", boot_size: "44" }
    }, headers: api_headers(@token), as: :json

    assert_response :created
    assert_equal "L", parsed_response["data"]["wetsuit_size"]
  end

  test "update updates equipment profile" do
    patch api_v1_customer_equipment_profile_path(@customer), params: {
      equipment_profile: { wetsuit_size: "XL" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "XL", parsed_response["data"]["wetsuit_size"]
  end

  test "destroy deletes equipment profile" do
    assert_difference "EquipmentProfile.count", -1 do
      delete api_v1_customer_equipment_profile_path(@customer), headers: api_headers(@token)
    end

    assert_response :no_content
  end

  test "requires authentication" do
    get api_v1_customer_equipment_profile_path(@customer)
    assert_response :unauthorized
  end
end
