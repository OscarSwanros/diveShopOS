# frozen_string_literal: true

require "test_helper"

class Api::V1::InstructorRatingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @rating = instructor_ratings(:maria_padi_instructor)
  end

  test "index returns ratings with pagination" do
    get api_v1_instructor_ratings_path, headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
    assert parsed_response["meta"]["total_count"].positive?
  end

  test "show returns rating" do
    get api_v1_instructor_rating_path(@rating), headers: api_headers(@token)

    assert_response :success
    assert_equal @rating.id, parsed_response["data"]["id"]
    assert_equal "PADI", parsed_response["data"]["agency"]
  end

  test "create creates rating" do
    assert_difference "InstructorRating.count", 1 do
      post api_v1_instructor_ratings_path, params: {
        instructor_rating: {
          user_id: users(:staff_ana).id, agency: "SSI",
          rating_level: "Instructor", active: true
        }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "create requires manager or owner" do
    staff_token = api_token_for(users(:staff_ana))
    post api_v1_instructor_ratings_path, params: {
      instructor_rating: { user_id: users(:staff_ana).id, agency: "NAUI", rating_level: "Instructor" }
    }, headers: api_headers(staff_token), as: :json

    assert_response :forbidden
  end

  test "update updates rating" do
    patch api_v1_instructor_rating_path(@rating), params: {
      instructor_rating: { rating_number: "PADI-999" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "PADI-999", parsed_response["data"]["rating_number"]
  end

  test "destroy deletes rating" do
    delete api_v1_instructor_rating_path(@rating), headers: api_headers(@token)
    assert_response :no_content
  end
end
