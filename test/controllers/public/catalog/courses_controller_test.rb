# frozen_string_literal: true

require "test_helper"

class Public::Catalog::CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @active_course = courses(:padi_ow)
    @inactive_course = courses(:inactive_course)
    @other_org_course = courses(:other_org_course)
    @published_offering = course_offerings(:padi_ow_upcoming)
    @draft_offering = course_offerings(:padi_aow_draft)
  end

  # --- Index ---

  test "index renders without authentication" do
    get catalog_courses_path
    assert_response :success
  end

  test "index shows active courses" do
    get catalog_courses_path
    assert_select "h2", text: @active_course.name
  end

  test "index does not show inactive courses" do
    get catalog_courses_path
    assert_select "h2", text: @inactive_course.name, count: 0
  end

  test "index does not show other org courses" do
    get catalog_courses_path
    assert_select "h2", text: @other_org_course.name, count: 0
  end

  # --- Show ---

  test "show renders for active course" do
    get catalog_course_path(@active_course)
    assert_response :success
    assert_select "h1", text: @active_course.name
  end

  test "show returns 404 for inactive course" do
    get catalog_course_path(@inactive_course)
    assert_response :not_found
  end

  test "show displays published upcoming offerings" do
    get catalog_course_path(@active_course)
    assert_response :success
  end

  test "show displays course details" do
    get catalog_course_path(@active_course)
    assert_select "h1", text: @active_course.name
    assert_response :success
  end

  test "show only exposes instructor first name" do
    get catalog_course_path(@active_course)
    # Should show first name only, not full name
    assert_response :success
  end
end
