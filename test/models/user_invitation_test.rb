# frozen_string_literal: true

require "test_helper"

class UserInvitationTest < ActiveSupport::TestCase
  test "valid invitation" do
    invitation = user_invitations(:pending_invitation)
    assert invitation.valid?
  end

  test "requires email" do
    invitation = user_invitations(:pending_invitation)
    invitation.email = nil
    assert_not invitation.valid?
  end

  test "requires valid email format" do
    invitation = user_invitations(:pending_invitation)
    invitation.email = "invalid"
    assert_not invitation.valid?
  end

  test "requires name" do
    invitation = user_invitations(:pending_invitation)
    invitation.name = nil
    assert_not invitation.valid?
  end

  test "find_by_token looks up by SHA256 digest" do
    invitation = UserInvitation.find_by_token("valid-invitation-token")
    assert_equal user_invitations(:pending_invitation), invitation
  end

  test "find_by_token returns nil for unknown token" do
    assert_nil UserInvitation.find_by_token("nonexistent")
  end

  test "find_by_token returns nil for blank token" do
    assert_nil UserInvitation.find_by_token("")
    assert_nil UserInvitation.find_by_token(nil)
  end

  test "pending? returns true for unexpired unaccepted invitation" do
    assert user_invitations(:pending_invitation).pending?
  end

  test "expired? returns true for expired invitation" do
    assert user_invitations(:expired_invitation).expired?
  end

  test "accepted? returns true for accepted invitation" do
    assert user_invitations(:accepted_invitation).accepted?
  end

  test "pending scope excludes expired and accepted" do
    pending = UserInvitation.pending
    assert_includes pending, user_invitations(:pending_invitation)
    assert_not_includes pending, user_invitations(:expired_invitation)
    assert_not_includes pending, user_invitations(:accepted_invitation)
  end

  test "normalizes email to lowercase" do
    invitation = user_invitations(:pending_invitation)
    invitation.email = "  TEST@Example.COM  "
    invitation.validate
    assert_equal "test@example.com", invitation.email
  end
end
