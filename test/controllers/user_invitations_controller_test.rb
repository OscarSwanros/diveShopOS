# frozen_string_literal: true

require "test_helper"

class UserInvitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = users(:owner_maria)
    @staff = users(:staff_ana)
  end

  test "owner can access new invitation form" do
    sign_in @owner
    get new_user_invitation_path
    assert_response :success
  end

  test "staff cannot access new invitation form" do
    sign_in @staff
    get new_user_invitation_path
    assert_response :forbidden
  end

  test "owner can create invitation" do
    sign_in @owner

    assert_difference "UserInvitation.count", 1 do
      post user_invitations_path, params: {
        name: "New Hire",
        email: "newhire@example.com",
        role: "staff"
      }
    end

    assert_redirected_to users_path
  end

  test "staff cannot create invitation" do
    sign_in @staff

    assert_no_difference "UserInvitation.count" do
      post user_invitations_path, params: {
        name: "New Hire",
        email: "newhire@example.com",
        role: "staff"
      }
    end

    assert_response :forbidden
  end

  test "owner can destroy invitation" do
    sign_in @owner

    assert_difference "UserInvitation.count", -1 do
      delete user_invitation_path(user_invitations(:pending_invitation))
    end

    assert_redirected_to users_path
  end

  test "requires authentication" do
    get new_user_invitation_path
    assert_redirected_to new_session_path
  end

  private

  def sign_in(user)
    post session_path, params: { email_address: user.email_address, password: "password123" }
  end
end
