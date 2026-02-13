# frozen_string_literal: true

require "test_helper"

class Api::V1::CustomerTanksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @customer = customers(:jane_diver)
    @tank = customer_tanks(:jane_al80)
  end

  test "index returns customer tanks" do
    get api_v1_customer_customer_tanks_path(@customer), headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
    assert parsed_response["meta"].present?
  end

  test "show returns customer tank" do
    get api_v1_customer_customer_tank_path(@customer, @tank), headers: api_headers(@token)

    assert_response :success
    assert_equal @tank.id, parsed_response["data"]["id"]
  end

  test "create creates customer tank" do
    assert_difference "CustomerTank.count", 1 do
      post api_v1_customer_customer_tanks_path(@customer), params: {
        customer_tank: {
          serial_number: "NEW-TANK-123",
          size: "AL80",
          material: "aluminum"
        }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
    assert_equal "NEW-TANK-123", parsed_response["data"]["serial_number"]
  end

  test "update updates customer tank" do
    patch api_v1_customer_customer_tank_path(@customer, @tank), params: {
      customer_tank: { size: "HP100" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "HP100", parsed_response["data"]["size"]
  end

  test "destroy deletes customer tank" do
    assert_difference "CustomerTank.count", -1 do
      delete api_v1_customer_customer_tank_path(@customer, @tank), headers: api_headers(@token)
    end

    assert_response :no_content
  end

  test "requires authentication" do
    get api_v1_customer_customer_tanks_path(@customer)
    assert_response :unauthorized
  end

  test "tenant isolation - cannot see other org tanks" do
    other_customer = customers(:other_org_customer)
    get api_v1_customer_customer_tanks_path(other_customer), headers: api_headers(@token)
    assert_response :not_found
  end

  test "show includes compliance fields" do
    get api_v1_customer_customer_tank_path(@customer, @tank), headers: api_headers(@token)

    data = parsed_response["data"]
    assert_not_nil data["vip_current"]
    assert_not_nil data["hydro_current"]
    assert_not_nil data["fill_compliant"]
  end
end
