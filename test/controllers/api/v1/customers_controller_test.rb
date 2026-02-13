# frozen_string_literal: true

require "test_helper"

class Api::V1::CustomersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @customer = customers(:jane_diver)
  end

  test "index returns customers with pagination" do
    get api_v1_customers_path, headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
    assert parsed_response["meta"]["total_count"].positive?
  end

  test "index requires authentication" do
    get api_v1_customers_path
    assert_response :unauthorized
  end

  test "index does not return other organization customers" do
    get api_v1_customers_path, headers: api_headers(@token)

    ids = parsed_response["data"].map { |c| c["id"] }
    refute_includes ids, customers(:other_org_customer).id
  end

  test "show returns customer" do
    get api_v1_customer_path(@customer), headers: api_headers(@token)

    assert_response :success
    assert_equal @customer.id, parsed_response["data"]["id"]
    assert_equal "Jane Diver", parsed_response["data"]["full_name"]
  end

  test "create creates customer" do
    assert_difference "Customer.count", 1 do
      post api_v1_customers_path, params: {
        customer: { first_name: "New", last_name: "Diver", email: "new@example.com" }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
    assert_equal "New", parsed_response["data"]["first_name"]
  end

  test "create returns validation errors" do
    post api_v1_customers_path, params: {
      customer: { first_name: "", last_name: "" }
    }, headers: api_headers(@token), as: :json

    assert_response :unprocessable_entity
    assert_equal "validation_failed", parsed_response["error"]["code"]
  end

  test "update updates customer" do
    patch api_v1_customer_path(@customer), params: {
      customer: { first_name: "Updated" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "Updated", parsed_response["data"]["first_name"]
  end

  test "destroy deactivates customer" do
    delete api_v1_customer_path(@customer), headers: api_headers(@token)

    assert_response :no_content
    refute @customer.reload.active
  end

  test "destroy requires manager or owner" do
    staff_token = api_token_for(users(:staff_ana))
    delete api_v1_customer_path(@customer), headers: api_headers(staff_token)

    assert_response :forbidden
  end
end
