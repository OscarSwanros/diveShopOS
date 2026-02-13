# frozen_string_literal: true

require "test_helper"

class Public::PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = customer_accounts(:jane_account)
  end

  test "new renders forgot password form" do
    get public_forgot_password_path
    assert_response :success
    assert_select "h1", text: I18n.t("public.password_resets.title")
  end

  test "create sends reset email for valid account" do
    assert_enqueued_emails 1 do
      post public_forgot_password_path, params: { email: @account.email }
    end
    assert_redirected_to public_login_path
  end

  test "create does not reveal non-existent email" do
    post public_forgot_password_path, params: { email: "nonexistent@example.com" }
    assert_redirected_to public_login_path
  end

  test "edit renders reset form with valid token" do
    token = @account.password_reset_token
    get public_edit_password_reset_path(token: token)
    assert_response :success
    assert_select "h1", text: I18n.t("public.password_resets.edit_title")
  end

  test "edit redirects with invalid token" do
    get public_edit_password_reset_path(token: "bad-token")
    assert_redirected_to public_forgot_password_path
  end

  test "update resets password with valid token" do
    token = @account.password_reset_token

    patch public_password_reset_path(token: token), params: {
      password: "newpassword123",
      password_confirmation: "newpassword123"
    }
    assert_redirected_to public_login_path

    @account.reload
    assert @account.authenticate("newpassword123")
  end

  test "update rejects invalid token" do
    patch public_password_reset_path(token: "bad-token"), params: {
      password: "newpassword123",
      password_confirmation: "newpassword123"
    }
    assert_redirected_to public_forgot_password_path
  end
end
