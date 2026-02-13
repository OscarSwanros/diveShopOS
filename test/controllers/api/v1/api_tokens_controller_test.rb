# frozen_string_literal: true

require "test_helper"

class Api::V1::ApiTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
  end

  test "index returns user tokens" do
    get api_v1_api_tokens_path, headers: api_headers(@token)

    assert_response :success
    data = parsed_response["data"]
    assert data.is_a?(Array)
    assert data.length >= 1
  end

  test "index requires authentication" do
    get api_v1_api_tokens_path

    assert_response :unauthorized
  end

  test "create generates a new token" do
    assert_difference "ApiToken.count", 1 do
      post api_v1_api_tokens_path, params: { name: "New Token" }, headers: api_headers(@token), as: :json
    end

    assert_response :created
    data = parsed_response["data"]
    assert data["token"].present?
    assert_equal "New Token", data["name"]
  end

  test "create with expires_at" do
    expires = 30.days.from_now.iso8601
    post api_v1_api_tokens_path, params: { name: "Expiring", expires_at: expires }, headers: api_headers(@token), as: :json

    assert_response :created
    assert parsed_response["data"]["expires_at"].present?
  end

  test "destroy revokes token" do
    target = @user.api_tokens.first

    delete api_v1_api_token_path(target), headers: api_headers(@token)

    assert_response :no_content
    assert target.reload.revoked?
  end

  test "destroy returns 404 for other user's token" do
    other_token = api_tokens(:other_org_token)

    delete api_v1_api_token_path(other_token), headers: api_headers(@token)

    assert_response :not_found
  end
end
