# frozen_string_literal: true

require "test_helper"

class Onboarding::AcceptInvitationTest < ActiveSupport::TestCase
  test "creates user and marks invitation as accepted" do
    assert_difference "User.count", 1 do
      result = Onboarding::AcceptInvitation.new(
        token: "valid-invitation-token",
        password: "newpassword123",
        password_confirmation: "newpassword123"
      ).call

      assert result.success
      assert_not_nil result.user
      assert_equal "New Staff", result.user.name
      assert_equal "newstaff@example.com", result.user.email_address
      assert result.user.staff?
    end

    invitation = user_invitations(:pending_invitation).reload
    assert invitation.accepted?
  end

  test "fails with invalid token" do
    result = Onboarding::AcceptInvitation.new(
      token: "nonexistent-token",
      password: "password123",
      password_confirmation: "password123"
    ).call

    assert_not result.success
    assert_equal I18n.t("onboarding.invitation.errors.invalid_token"), result.error
  end

  test "fails with already accepted invitation" do
    result = Onboarding::AcceptInvitation.new(
      token: "accepted-invitation-token",
      password: "password123",
      password_confirmation: "password123"
    ).call

    assert_not result.success
    assert_equal I18n.t("onboarding.invitation.errors.already_accepted"), result.error
  end

  test "fails with expired invitation" do
    result = Onboarding::AcceptInvitation.new(
      token: "expired-invitation-token",
      password: "password123",
      password_confirmation: "password123"
    ).call

    assert_not result.success
    assert_equal I18n.t("onboarding.invitation.errors.expired"), result.error
  end

  test "fails when passwords do not match" do
    result = Onboarding::AcceptInvitation.new(
      token: "valid-invitation-token",
      password: "password1",
      password_confirmation: "password2"
    ).call

    assert_not result.success
    assert_not_nil result.error
  end
end
