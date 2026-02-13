# frozen_string_literal: true

require "test_helper"

class Api::V1::CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @course = courses(:padi_ow)
  end

  test "index returns courses with pagination" do
    get api_v1_courses_path, headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
    assert parsed_response["meta"]["total_count"].positive?
  end

  test "index filters by agency" do
    get api_v1_courses_path(agency: "PADI"), headers: api_headers(@token)

    assert_response :success
    parsed_response["data"].each do |course|
      assert_equal "PADI", course["agency"]
    end
  end

  test "index filters by course_type" do
    get api_v1_courses_path(course_type: "specialty"), headers: api_headers(@token)

    assert_response :success
    parsed_response["data"].each do |course|
      assert_equal "specialty", course["course_type"]
    end
  end

  test "index does not return other org courses" do
    get api_v1_courses_path, headers: api_headers(@token)

    ids = parsed_response["data"].map { |c| c["id"] }
    refute_includes ids, courses(:other_org_course).id
  end

  test "show returns course" do
    get api_v1_course_path(@course), headers: api_headers(@token)

    assert_response :success
    assert_equal @course.id, parsed_response["data"]["id"]
  end

  test "create creates course" do
    assert_difference "Course.count", 1 do
      post api_v1_courses_path, params: {
        course: {
          name: "New Course", agency: "PADI", level: "Rescue",
          course_type: "certification", max_students: 6, price_cents: 40000
        }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "create requires manager or owner" do
    staff_token = api_token_for(users(:staff_ana))
    post api_v1_courses_path, params: {
      course: { name: "Fail", agency: "PADI", level: "Test", course_type: "certification", max_students: 4 }
    }, headers: api_headers(staff_token), as: :json

    assert_response :forbidden
  end

  test "update updates course" do
    patch api_v1_course_path(@course), params: {
      course: { name: "Updated Course Name" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "Updated Course Name", parsed_response["data"]["name"]
  end

  test "destroy deletes course" do
    course = courses(:inactive_course)
    delete api_v1_course_path(course), headers: api_headers(@token)

    assert_response :no_content
  end
end
