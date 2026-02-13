# frozen_string_literal: true

require "test_helper"

class EnrollmentReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @owner = users(:owner_maria)
    @staff = users(:staff_ana)
    @offering = course_offerings(:padi_ow_upcoming)
    @minor = customers(:minor_diver)

    # Use a customer without existing enrollments in this offering to avoid FK issues
    @enrollment = @offering.enrollments.create!(
      customer: @minor,
      status: :requested,
      requested_at: Time.current,
      slug: "minor-review-test"
    )
  end

  def sign_in_staff(user)
    post session_path, params: { email_address: user.email_address, password: "password123" }
  end

  test "approve requires authentication" do
    post approve_enrollment_review_path(@enrollment)
    assert_redirected_to new_session_path
  end

  test "approve changes status to confirmed" do
    sign_in_staff(@owner)
    post approve_enrollment_review_path(@enrollment)

    @enrollment.reload
    assert_equal "confirmed", @enrollment.status
    assert_not_nil @enrollment.enrolled_at
    assert_redirected_to review_queue_path
  end

  test "approve sends notification email" do
    sign_in_staff(@owner)

    assert_enqueued_emails 1 do
      post approve_enrollment_review_path(@enrollment)
    end
  end

  test "approve denied for staff role" do
    sign_in_staff(@staff)
    assert_raises(Pundit::NotAuthorizedError) do
      post approve_enrollment_review_path(@enrollment)
    end
  end

  test "decline changes status to declined with reason" do
    sign_in_staff(@owner)
    post decline_enrollment_review_path(@enrollment), params: { reason: "Prerequisites not met" }

    @enrollment.reload
    assert_equal "declined", @enrollment.status
    assert_equal "Prerequisites not met", @enrollment.declined_reason
    assert_not_nil @enrollment.declined_at
    assert_redirected_to review_queue_path
  end

  test "decline sends notification email" do
    sign_in_staff(@owner)

    assert_enqueued_emails 1 do
      post decline_enrollment_review_path(@enrollment), params: { reason: "Not eligible" }
    end
  end
end
