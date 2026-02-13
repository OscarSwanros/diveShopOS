# frozen_string_literal: true

require "test_helper"

class Onboarding::InvitationAcceptancesControllerTest < ActionDispatch::IntegrationTest
  test "GET acceptance page renders for valid pending token" do
    get accept_invitation_path(token: "valid-invitation-token")
    assert_response :success
  end

  test "GET acceptance page redirects for invalid token" do
    get accept_invitation_path(token: "invalid-token")
    assert_redirected_to new_session_path
  end

  test "GET acceptance page redirects for expired token" do
    get accept_invitation_path(token: "expired-invitation-token")
    assert_redirected_to new_session_path
  end

  test "POST creates user and logs in" do
    assert_difference "User.count", 1 do
      post accept_invitation_path(token: "valid-invitation-token"), params: {
        password: "newpassword123",
        password_confirmation: "newpassword123"
      }
    end

    assert_redirected_to root_path
    user = User.find_by(email_address: "newstaff@example.com")
    assert_not_nil user
    assert user.staff?
  end

  test "POST with invalid password re-renders form" do
    assert_no_difference "User.count" do
      post accept_invitation_path(token: "valid-invitation-token"), params: {
        password: "a",
        password_confirmation: "b"
      }
    end

    assert_response :unprocessable_entity
  end
end
