# frozen_string_literal: true

require "test_helper"

class JoinRequestReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @owner = users(:owner_maria)
    @staff = users(:staff_ana)
    @excursion = excursions(:morning_reef)
    @bob = customers(:bob_bubbles)

    # Create a requested join for review
    @participant = @excursion.trip_participants.create!(
      customer: @bob,
      name: @bob.full_name,
      email: @bob.email,
      role: :diver,
      status: :tp_requested,
      requested_at: Time.current,
      slug: "bob-join-review-test"
    )
  end

  def sign_in_staff(user)
    post session_path, params: { email_address: user.email_address, password: "password123" }
  end

  test "approve requires authentication" do
    post approve_join_request_review_path(@participant)
    assert_redirected_to new_session_path
  end

  test "approve changes status to tp_confirmed" do
    sign_in_staff(@owner)
    post approve_join_request_review_path(@participant)

    @participant.reload
    assert_equal "tp_confirmed", @participant.status
    assert_redirected_to review_queue_path
  end

  test "approve sends notification email" do
    sign_in_staff(@owner)

    assert_enqueued_emails 1 do
      post approve_join_request_review_path(@participant)
    end
  end

  test "approve denied for staff role" do
    sign_in_staff(@staff)
    assert_raises(Pundit::NotAuthorizedError) do
      post approve_join_request_review_path(@participant)
    end
  end

  test "decline changes status to tp_cancelled with reason" do
    sign_in_staff(@owner)
    post decline_join_request_review_path(@participant), params: { reason: "No certification on file" }

    @participant.reload
    assert_equal "tp_cancelled", @participant.status
    assert_equal "No certification on file", @participant.declined_reason
    assert_not_nil @participant.declined_at
    assert_redirected_to review_queue_path
  end

  test "decline sends notification email" do
    sign_in_staff(@owner)

    assert_enqueued_emails 1 do
      post decline_join_request_review_path(@participant), params: { reason: "Not eligible" }
    end
  end
end
