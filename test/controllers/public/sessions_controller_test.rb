# frozen_string_literal: true

require "test_helper"

class Public::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_account = customer_accounts(:jane_account)
    @unconfirmed_account = customer_accounts(:bob_account_unconfirmed)
  end

  test "new renders login form" do
    get public_login_path
    assert_response :success
    assert_select "h1", text: I18n.t("public.sessions.title")
  end

  test "create signs in confirmed account" do
    post public_login_path, params: { email: @confirmed_account.email, password: "password123" }
    assert_redirected_to my_dashboard_path
  end

  test "create rejects unconfirmed account" do
    post public_login_path, params: { email: @unconfirmed_account.email, password: "password123" }
    assert_redirected_to public_login_path
    follow_redirect!
    assert_select "div[role='alert']", text: I18n.t("public.sessions.unconfirmed")
  end

  test "create rejects invalid credentials" do
    post public_login_path, params: { email: @confirmed_account.email, password: "wrongpassword" }
    assert_response :unprocessable_entity
  end

  test "destroy signs out customer" do
    # Sign in first
    post public_login_path, params: { email: @confirmed_account.email, password: "password123" }
    follow_redirect!

    delete public_logout_path
    assert_redirected_to catalog_excursions_path
  end
end
