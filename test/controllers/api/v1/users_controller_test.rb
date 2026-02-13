# frozen_string_literal: true

require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = users(:owner_maria)
    @token = api_token_for(@owner)
    @user = users(:staff_ana)
  end

  test "index returns users with pagination" do
    get api_v1_users_path, headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
    assert parsed_response["meta"]["total_count"].positive?
  end

  test "index requires authentication" do
    get api_v1_users_path
    assert_response :unauthorized
  end

  test "index does not return other organization users" do
    get api_v1_users_path, headers: api_headers(@token)

    ids = parsed_response["data"].map { |u| u["id"] }
    refute_includes ids, users(:other_org_user).id
  end

  test "show returns user" do
    get api_v1_user_path(@user), headers: api_headers(@token)

    assert_response :success
    assert_equal @user.id, parsed_response["data"]["id"]
  end

  test "create creates user as owner" do
    assert_difference "User.count", 1 do
      post api_v1_users_path, params: {
        user: { name: "New User", email_address: "newuser@reefdivers.com", password: "password123", password_confirmation: "password123" }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "create requires owner role" do
    staff_token = api_token_for(users(:staff_ana))
    post api_v1_users_path, params: {
      user: { name: "Fail", email_address: "fail@test.com", password: "password123", password_confirmation: "password123" }
    }, headers: api_headers(staff_token), as: :json

    assert_response :forbidden
  end

  test "update updates user" do
    patch api_v1_user_path(@user), params: {
      user: { name: "Updated Name" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "Updated Name", parsed_response["data"]["name"]
  end

  test "destroy deletes user" do
    assert_difference "User.count", -1 do
      delete api_v1_user_path(@user), headers: api_headers(@token)
    end
    assert_response :no_content
  end

  test "destroy prevents self-deletion" do
    delete api_v1_user_path(@owner), headers: api_headers(@token)
    assert_response :forbidden
  end
end
