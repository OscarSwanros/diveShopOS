# frozen_string_literal: true

require "test_helper"

class Api::V1::SessionAttendancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @course = courses(:padi_ow)
    @offering = course_offerings(:padi_ow_upcoming)
    @session = class_sessions(:ow_classroom_1)
    @attendance = session_attendances(:jane_classroom_1)
  end

  test "batch_update updates attendances" do
    patch batch_update_api_v1_course_course_offering_class_session_session_attendances_path(
      @course, @offering, @session
    ), params: {
      attendances: [
        { id: @attendance.id, attended: false }
      ]
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
    refute @attendance.reload.attended
  end

  test "batch_update requires authentication" do
    patch batch_update_api_v1_course_course_offering_class_session_session_attendances_path(
      @course, @offering, @session
    ), params: { attendances: [] }, as: :json

    assert_response :unauthorized
  end
end
