# frozen_string_literal: true

require "test_helper"

class Onboarding::InviteStaffMemberTest < ActiveSupport::TestCase
  setup do
    @org = organizations(:reef_divers)
    @owner = users(:owner_maria)
  end

  test "creates invitation successfully" do
    assert_difference "UserInvitation.count", 1 do
      result = Onboarding::InviteStaffMember.new(
        organization: @org,
        invited_by: @owner,
        name: "New Person",
        email: "new@example.com"
      ).call

      assert result.success
      assert_not_nil result.invitation
      assert_equal "new@example.com", result.invitation.email
      assert_equal "New Person", result.invitation.name
      assert result.invitation.staff?
    end
  end

  test "creates manager invitation when role specified" do
    result = Onboarding::InviteStaffMember.new(
      organization: @org,
      invited_by: @owner,
      name: "Manager Person",
      email: "manager@example.com",
      role: :manager
    ).call

    assert result.success
    assert result.invitation.manager?
  end

  test "fails when email already has pending invitation" do
    result = Onboarding::InviteStaffMember.new(
      organization: @org,
      invited_by: @owner,
      name: "Duplicate",
      email: "newstaff@example.com"
    ).call

    assert_not result.success
    assert_equal I18n.t("onboarding.invitation.errors.already_invited"), result.error
  end

  test "fails when email belongs to existing staff member" do
    result = Onboarding::InviteStaffMember.new(
      organization: @org,
      invited_by: @owner,
      name: "Existing",
      email: @owner.email_address
    ).call

    assert_not result.success
    assert_equal I18n.t("onboarding.invitation.errors.already_staff"), result.error
  end

  test "stores SHA256 token digest" do
    result = Onboarding::InviteStaffMember.new(
      organization: @org,
      invited_by: @owner,
      name: "Token Test",
      email: "token@example.com"
    ).call

    assert result.success
    assert_equal 64, result.invitation.token_digest.length
  end

  test "sets expiry to 7 days from now" do
    result = Onboarding::InviteStaffMember.new(
      organization: @org,
      invited_by: @owner,
      name: "Expiry Test",
      email: "expiry@example.com"
    ).call

    assert result.success
    assert_in_delta 7.days.from_now, result.invitation.expires_at, 5.seconds
  end
end
