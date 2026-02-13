# frozen_string_literal: true

require "test_helper"

class Api::V1::CourseOfferingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @course = courses(:padi_ow)
    @offering = course_offerings(:padi_ow_upcoming)
  end

  test "index returns offerings for course" do
    get api_v1_course_course_offerings_path(@course), headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
  end

  test "show returns offering with spots remaining" do
    get api_v1_course_course_offering_path(@course, @offering), headers: api_headers(@token)

    assert_response :success
    assert_equal @offering.id, parsed_response["data"]["id"]
    assert parsed_response["data"].key?("spots_remaining")
  end

  test "create creates offering" do
    assert_difference "CourseOffering.count", 1 do
      post api_v1_course_course_offerings_path(@course), params: {
        course_offering: {
          instructor_id: @user.id, start_date: Date.current + 30.days,
          max_students: 6, status: "draft"
        }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "create requires manager or owner" do
    staff_token = api_token_for(users(:staff_ana))
    post api_v1_course_course_offerings_path(@course), params: {
      course_offering: { instructor_id: @user.id, start_date: Date.current + 30.days, max_students: 6 }
    }, headers: api_headers(staff_token), as: :json

    assert_response :forbidden
  end

  test "update updates offering" do
    patch api_v1_course_course_offering_path(@course, @offering), params: {
      course_offering: { max_students: 10 }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal 10, parsed_response["data"]["max_students"]
  end

  test "destroy deletes offering" do
    offering = course_offerings(:padi_aow_draft)
    course = courses(:padi_aow)
    delete api_v1_course_course_offering_path(course, offering), headers: api_headers(@token)

    assert_response :no_content
  end
end
