# frozen_string_literal: true

require "test_helper"

class Public::EnrollmentRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @course = courses(:padi_ow)
    @offering = course_offerings(:padi_ow_upcoming)
    @jane_account = customer_accounts(:jane_account)
    @jane = customers(:jane_diver)
  end

  def sign_in_customer(account)
    post public_login_path, params: { email: account.email, password: "password123" }
  end

  # --- Authentication ---

  test "new redirects unauthenticated customer to login" do
    get new_enrollment_request_path(course_slug: @course.slug, offering_slug: @offering.slug)
    assert_redirected_to public_login_path
  end

  test "create redirects unauthenticated customer to login" do
    post enrollment_request_path(course_slug: @course.slug, offering_slug: @offering.slug)
    assert_redirected_to public_login_path
  end

  # --- New ---

  test "new renders for authenticated customer" do
    sign_in_customer(@jane_account)
    get new_enrollment_request_path(course_slug: @course.slug, offering_slug: @offering.slug)
    assert_response :success
  end

  test "new returns 404 for draft offering" do
    sign_in_customer(@jane_account)
    draft_offering = course_offerings(:padi_aow_draft)
    get new_enrollment_request_path(course_slug: draft_offering.course.slug, offering_slug: draft_offering.slug)
    assert_response :not_found
  end

  # --- Create ---

  test "create submits enrollment request" do
    sign_in_customer(@jane_account)

    # Jane already has enrollment in padi_ow_upcoming from fixtures; use a different customer
    # First, withdraw Jane's existing enrollment so she can re-request
    @jane.enrollments.where(course_offering: @offering).update_all(status: :withdrawn)

    assert_difference "Enrollment.count", 1 do
      post enrollment_request_path(course_slug: @course.slug, offering_slug: @offering.slug)
    end

    enrollment = @jane.enrollments.where(course_offering: @offering, status: :requested).first
    assert_not_nil enrollment
    assert_equal "requested", enrollment.status
    assert enrollment.safety_gate_results.present?
    assert_redirected_to catalog_course_path(@course)
  end

  test "create sends customer and staff emails" do
    sign_in_customer(@jane_account)
    @jane.enrollments.where(course_offering: @offering).update_all(status: :withdrawn)

    assert_enqueued_emails 2 do
      post enrollment_request_path(course_slug: @course.slug, offering_slug: @offering.slug)
    end
  end

  test "create rejects duplicate enrollment request" do
    sign_in_customer(@jane_account)
    # Jane already has an active enrollment in the fixture

    assert_no_difference "Enrollment.count" do
      post enrollment_request_path(course_slug: @course.slug, offering_slug: @offering.slug)
    end

    assert_response :unprocessable_entity
  end
end
