# frozen_string_literal: true

require "test_helper"

class Api::V1::EnrollmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @course = courses(:padi_ow)
    @offering = course_offerings(:padi_ow_upcoming)
    @enrollment = enrollments(:jane_in_ow)
  end

  test "index returns enrollments for offering" do
    get api_v1_course_course_offering_enrollments_path(@course, @offering), headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
  end

  test "show returns enrollment" do
    get api_v1_course_course_offering_enrollment_path(@course, @offering, @enrollment), headers: api_headers(@token)

    assert_response :success
    assert_equal @enrollment.id, parsed_response["data"]["id"]
  end

  test "create enrolls student with safety gates" do
    # Use the AOW draft offering (no existing enrollments, no water sessions so medical gate passes)
    course = courses(:padi_aow)
    offering = course_offerings(:padi_aow_draft)

    assert_difference "Enrollment.count", 1 do
      post api_v1_course_course_offering_enrollments_path(course, offering), params: {
        enrollment: { customer_id: customers(:jane_diver).id }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "create rejects when at capacity" do
    full_offering = course_offerings(:padi_ow_full)

    post api_v1_course_course_offering_enrollments_path(@course, full_offering), params: {
      enrollment: { customer_id: customers(:minor_diver).id }
    }, headers: api_headers(@token), as: :json

    assert_response :unprocessable_entity
    assert_equal "safety_gate_failed", parsed_response["error"]["code"]
  end

  test "update updates enrollment" do
    patch api_v1_course_course_offering_enrollment_path(@course, @offering, @enrollment), params: {
      enrollment: { paid: true, notes: "Updated via API" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
  end

  test "complete marks enrollment completed" do
    # Jane has attended all sessions
    post complete_api_v1_course_course_offering_enrollment_path(@course, @offering, @enrollment),
      headers: api_headers(@token)

    assert_response :success
    assert_equal "completed", parsed_response["data"]["status"]
  end

  test "complete fails when sessions not attended" do
    enrollment = enrollments(:bob_in_ow) # Bob hasn't attended all sessions

    post complete_api_v1_course_course_offering_enrollment_path(@course, @offering, enrollment),
      headers: api_headers(@token)

    assert_response :unprocessable_entity
    assert_equal "completion_failed", parsed_response["error"]["code"]
  end

  test "destroy withdraws enrollment" do
    delete api_v1_course_course_offering_enrollment_path(@course, @offering, @enrollment), headers: api_headers(@token)

    assert_response :no_content
    assert @enrollment.reload.withdrawn?
  end
end
