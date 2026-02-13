# frozen_string_literal: true

require "test_helper"

class Public::JoinRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @excursion = excursions(:morning_reef)
    @jane_account = customer_accounts(:jane_account)
    @jane = customers(:jane_diver)
  end

  def sign_in_customer(account)
    post public_login_path, params: { email: account.email, password: "password123" }
  end

  # --- Authentication ---

  test "new redirects unauthenticated customer to login" do
    get new_join_request_path(excursion_slug: @excursion.slug)
    assert_redirected_to public_login_path
  end

  test "create redirects unauthenticated customer to login" do
    post join_request_path(excursion_slug: @excursion.slug)
    assert_redirected_to public_login_path
  end

  # --- New ---

  test "new renders for authenticated customer" do
    sign_in_customer(@jane_account)
    get new_join_request_path(excursion_slug: @excursion.slug)
    assert_response :success
  end

  test "new returns 404 for draft excursion" do
    sign_in_customer(@jane_account)
    draft = excursions(:draft_trip)
    get new_join_request_path(excursion_slug: draft.slug)
    assert_response :not_found
  end

  # --- Create ---

  test "create submits join request" do
    sign_in_customer(@jane_account)

    # Existing fixture participants don't have customer_id set, so duplicate check passes
    assert_difference "TripParticipant.count", 1 do
      post join_request_path(excursion_slug: @excursion.slug)
    end

    participant = TripParticipant.where(excursion: @excursion, customer: @jane, status: :tp_requested).first
    assert_not_nil participant
    assert_equal "tp_requested", participant.status
    assert_equal @jane.id, participant.customer_id
    assert_redirected_to catalog_excursion_path(@excursion)
  end

  test "create sends customer and staff emails" do
    sign_in_customer(@jane_account)

    assert_enqueued_emails 2 do
      post join_request_path(excursion_slug: @excursion.slug)
    end
  end

  test "create rejects duplicate with existing customer_id participant" do
    sign_in_customer(@jane_account)

    # Give Jane's existing participant a customer_id and non-cancelled status
    tp = trip_participants(:diver_jane)
    tp.update_columns(customer_id: @jane.id, status: TripParticipant.statuses[:tp_confirmed])

    assert_no_difference "TripParticipant.count" do
      post join_request_path(excursion_slug: @excursion.slug)
    end

    assert_response :unprocessable_entity
  end
end
