# frozen_string_literal: true

require "test_helper"

class Api::V1::EquipmentItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @item = equipment_items(:bcd_medium)
  end

  test "index returns equipment items" do
    get api_v1_equipment_items_path, headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
    assert parsed_response["meta"].present?
  end

  test "index filters by category" do
    get api_v1_equipment_items_path(category: "regulator"), headers: api_headers(@token)

    assert_response :success
    parsed_response["data"].each do |item|
      assert_equal "regulator", item["category"]
    end
  end

  test "index filters by status" do
    get api_v1_equipment_items_path(status: "available"), headers: api_headers(@token)

    assert_response :success
    parsed_response["data"].each do |item|
      assert_equal "available", item["status"]
    end
  end

  test "show returns equipment item" do
    get api_v1_equipment_item_path(@item), headers: api_headers(@token)

    assert_response :success
    assert_equal @item.id, parsed_response["data"]["id"]
    assert_equal @item.name, parsed_response["data"]["name"]
  end

  test "create creates equipment item" do
    assert_difference "EquipmentItem.count", 1 do
      post api_v1_equipment_items_path, params: {
        equipment_item: { category: "fins", name: "New Fins", size: "L" }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "create validates life support serial number" do
    post api_v1_equipment_items_path, params: {
      equipment_item: { category: "regulator", name: "New Reg", life_support: true }
    }, headers: api_headers(@token), as: :json

    assert_response :unprocessable_entity
    assert_equal "validation_failed", parsed_response["error"]["code"]
  end

  test "update updates equipment item" do
    patch api_v1_equipment_item_path(@item), params: {
      equipment_item: { name: "Updated BCD Name" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "Updated BCD Name", parsed_response["data"]["name"]
  end

  test "destroy deletes equipment item" do
    assert_difference "EquipmentItem.count", -1 do
      delete api_v1_equipment_item_path(@item), headers: api_headers(@token)
    end

    assert_response :no_content
  end

  test "requires authentication" do
    get api_v1_equipment_items_path
    assert_response :unauthorized
  end

  test "tenant isolation - cannot see other org items" do
    other = equipment_items(:other_org_equipment)
    get api_v1_equipment_item_path(other), headers: api_headers(@token)
    assert_response :not_found
  end

  test "show includes service status fields" do
    get api_v1_equipment_item_path(@item), headers: api_headers(@token)

    data = parsed_response["data"]
    assert_not_nil data["service_current"]
    assert_not_nil data["service_overdue"]
  end
end
