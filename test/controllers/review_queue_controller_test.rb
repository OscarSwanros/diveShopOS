# frozen_string_literal: true

require "test_helper"

class ReviewQueueControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @owner = users(:owner_maria)
    @staff = users(:staff_ana)
  end

  def sign_in_staff(user)
    post session_path, params: { email_address: user.email_address, password: "password123" }
  end

  test "show requires staff authentication" do
    get review_queue_path
    assert_redirected_to new_session_path
  end

  test "show renders for authenticated staff" do
    sign_in_staff(@owner)
    get review_queue_path
    assert_response :success
  end

  test "show displays pending enrollment requests" do
    offering = course_offerings(:padi_ow_upcoming)
    minor = customers(:minor_diver)
    enrollment = offering.enrollments.create!(
      customer: minor,
      status: :requested,
      requested_at: Time.current,
      slug: "minor-queue-test"
    )

    sign_in_staff(@owner)
    get review_queue_path
    assert_response :success
    assert_select "td", text: minor.full_name
  end

  test "show displays pending join requests" do
    excursion = excursions(:morning_reef)
    minor = customers(:minor_diver)
    participant = excursion.trip_participants.create!(
      customer: minor,
      name: minor.full_name,
      role: :diver,
      status: :tp_requested,
      requested_at: Time.current,
      slug: "minor-join-queue-test"
    )

    sign_in_staff(@owner)
    get review_queue_path
    assert_response :success
    assert_select "td", text: minor.full_name
  end
end
