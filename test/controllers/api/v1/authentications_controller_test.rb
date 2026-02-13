# frozen_string_literal: true

require "test_helper"

class Api::V1::AuthenticationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
  end

  test "create returns token for valid credentials" do
    post api_v1_authentication_path, params: { email: @user.email_address, password: "password123" }, as: :json

    assert_response :created
    data = parsed_response["data"]
    assert data["token"].present?
    assert data["token_id"].present?
    assert_equal @user.name, data["user"]["name"]
    assert_equal @user.email_address, data["user"]["email"]
    assert_equal @user.organization_id, data["user"]["organization_id"]
  end

  test "create returns token with custom name" do
    post api_v1_authentication_path, params: { email: @user.email_address, password: "password123", name: "My App" }, as: :json

    assert_response :created
    assert_equal "My App", parsed_response["data"]["name"]
  end

  test "created token can be used for authentication" do
    post api_v1_authentication_path, params: { email: @user.email_address, password: "password123" }, as: :json

    token = parsed_response["data"]["token"]
    get api_v1_customers_path, headers: api_headers(token)
    assert_response :success
  end

  test "create returns 401 for invalid email" do
    post api_v1_authentication_path, params: { email: "wrong@example.com", password: "password123" }, as: :json

    assert_response :unauthorized
    assert_equal "invalid_credentials", parsed_response["error"]["code"]
  end

  test "create returns 401 for invalid password" do
    post api_v1_authentication_path, params: { email: @user.email_address, password: "wrong" }, as: :json

    assert_response :unauthorized
    assert_equal "invalid_credentials", parsed_response["error"]["code"]
  end
end
