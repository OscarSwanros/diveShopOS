# frozen_string_literal: true

require "test_helper"

class Public::CancellationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @jane_account = customer_accounts(:jane_account)
    @jane = customers(:jane_diver)
  end

  def sign_in_customer(account)
    post public_login_path, params: { email: account.email, password: "password123" }
  end

  # --- Authentication ---

  test "cancel_enrollment redirects unauthenticated customer" do
    enrollment = enrollments(:jane_in_ow)
    post cancel_enrollment_path(enrollment)
    assert_redirected_to public_login_path
  end

  test "cancel_join redirects unauthenticated customer" do
    post cancel_join_path("some-slug")
    assert_redirected_to public_login_path
  end

  # --- Cancel Enrollment ---

  test "cancel_enrollment withdraws confirmed enrollment" do
    sign_in_customer(@jane_account)
    enrollment = enrollments(:jane_in_ow)

    post cancel_enrollment_path(enrollment)

    assert_redirected_to my_dashboard_path
    enrollment.reload
    assert enrollment.withdrawn?
  end

  test "cancel_enrollment sends staff notification" do
    sign_in_customer(@jane_account)
    enrollment = enrollments(:jane_in_ow)

    assert_enqueued_emails 1 do
      post cancel_enrollment_path(enrollment)
    end
  end

  test "cancel_enrollment returns 404 for another customer's enrollment" do
    sign_in_customer(@jane_account)
    bob_enrollment = enrollments(:bob_in_ow)

    post cancel_enrollment_path(bob_enrollment)
    assert_response :not_found
  end

  test "cancel_enrollment returns 404 for already withdrawn enrollment" do
    sign_in_customer(@jane_account)
    # Withdraw all of Jane's enrollments so none match the active status filter
    @jane.enrollments.where.not(status: [ :withdrawn, :failed, :declined ]).each(&:withdraw!)

    post cancel_enrollment_path("jane-diver")
    assert_response :not_found
  end

  # --- Cancel Join ---

  test "cancel_join cancels trip participation" do
    sign_in_customer(@jane_account)
    participation = TripParticipant.create!(
      excursion: excursions(:morning_reef),
      customer: @jane,
      name: @jane.full_name,
      role: :diver,
      status: :tp_confirmed
    )

    post cancel_join_path(participation)

    assert_redirected_to my_dashboard_path
    participation.reload
    assert participation.booking_tp_cancelled?
  end

  test "cancel_join sends staff notification" do
    sign_in_customer(@jane_account)
    participation = TripParticipant.create!(
      excursion: excursions(:morning_reef),
      customer: @jane,
      name: @jane.full_name,
      role: :diver,
      status: :tp_confirmed
    )

    assert_enqueued_emails 1 do
      post cancel_join_path(participation)
    end
  end

  test "cancel_join returns 404 for participation without customer link" do
    sign_in_customer(@jane_account)
    # The fixture diver_jane has no customer_id set
    legacy_participation = trip_participants(:diver_jane)

    post cancel_join_path(legacy_participation)
    assert_response :not_found
  end
end
