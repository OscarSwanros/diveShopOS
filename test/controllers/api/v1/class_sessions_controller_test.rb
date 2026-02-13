# frozen_string_literal: true

require "test_helper"

class Api::V1::ClassSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @course = courses(:padi_ow)
    @offering = course_offerings(:padi_ow_upcoming)
    @session = class_sessions(:ow_classroom_1)
  end

  test "index returns sessions for offering" do
    get api_v1_course_course_offering_class_sessions_path(@course, @offering), headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
  end

  test "show returns session" do
    get api_v1_course_course_offering_class_session_path(@course, @offering, @session), headers: api_headers(@token)

    assert_response :success
    assert_equal @session.id, parsed_response["data"]["id"]
  end

  test "create creates session" do
    assert_difference "ClassSession.count", 1 do
      post api_v1_course_course_offering_class_sessions_path(@course, @offering), params: {
        class_session: {
          session_type: "classroom", title: "New Session",
          scheduled_date: Date.current + 15.days, start_time: "10:00"
        }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "update updates session" do
    patch api_v1_course_course_offering_class_session_path(@course, @offering, @session), params: {
      class_session: { title: "Updated Title" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "Updated Title", parsed_response["data"]["title"]
  end

  test "destroy deletes session" do
    delete api_v1_course_course_offering_class_session_path(@course, @offering, @session), headers: api_headers(@token)

    assert_response :no_content
  end

  test "requires manager or owner for create" do
    staff_token = api_token_for(users(:staff_ana))
    post api_v1_course_course_offering_class_sessions_path(@course, @offering), params: {
      class_session: { session_type: "classroom", title: "Fail", scheduled_date: Date.current + 15.days, start_time: "10:00" }
    }, headers: api_headers(staff_token), as: :json

    assert_response :forbidden
  end
end
