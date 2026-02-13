# frozen_string_literal: true

require "test_helper"

class Public::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unconfirmed = customer_accounts(:bob_account_unconfirmed)
    @confirmed = customer_accounts(:jane_account)
  end

  test "show confirms valid token" do
    get public_confirm_email_path(token: @unconfirmed.confirmation_token)
    assert_redirected_to public_login_path
    @unconfirmed.reload
    assert @unconfirmed.confirmed?
  end

  test "show rejects invalid token" do
    get public_confirm_email_path(token: "bad-token")
    assert_redirected_to public_login_path
    follow_redirect!
    assert_select "div[role='alert']", text: I18n.t("public.confirmations.invalid_token")
  end

  test "show handles already confirmed" do
    @confirmed.update!(confirmation_token: "some-token")
    get public_confirm_email_path(token: "some-token")
    assert_redirected_to public_login_path
  end

  test "pending renders check email page" do
    get public_confirmation_pending_path(email: "bob@example.com")
    assert_response :success
    assert_select "h1", text: I18n.t("public.confirmations.pending.title")
  end

  test "resend sends new confirmation email" do
    assert_enqueued_emails 1 do
      post public_resend_confirmation_path, params: { email: @unconfirmed.email }
    end
    assert_redirected_to public_confirmation_pending_path(email: @unconfirmed.email)
  end

  test "resend does not reveal non-existent email" do
    post public_resend_confirmation_path, params: { email: "nonexistent@example.com" }
    assert_redirected_to public_confirmation_pending_path(email: "nonexistent@example.com")
  end
end
