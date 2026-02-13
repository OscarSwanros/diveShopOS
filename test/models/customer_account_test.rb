# frozen_string_literal: true

require "test_helper"

class CustomerAccountTest < ActiveSupport::TestCase
  setup do
    @account = customer_accounts(:jane_account)
    @unconfirmed = customer_accounts(:bob_account_unconfirmed)
  end

  # --- Associations ---

  test "belongs to organization" do
    assert_equal organizations(:reef_divers), @account.organization
  end

  test "belongs to customer" do
    assert_equal customers(:jane_diver), @account.customer
  end

  # --- Validations ---

  test "requires email" do
    @account.email = nil
    assert_not @account.valid?
  end

  test "requires unique email per organization" do
    new_account = CustomerAccount.new(
      organization: @account.organization,
      customer: customers(:minor_diver),
      email: @account.email,
      password: "password123"
    )
    assert_not new_account.valid?
    assert new_account.errors[:email].any?
  end

  test "normalizes email" do
    @account.email = "  JANE@EXAMPLE.COM  "
    @account.valid?
    assert_equal "jane@example.com", @account.email
  end

  # --- Confirmation ---

  test "confirmed? returns true when confirmed_at is set" do
    assert @account.confirmed?
  end

  test "confirmed? returns false when confirmed_at is nil" do
    assert_not @unconfirmed.confirmed?
  end

  test "confirm! sets confirmed_at and clears token" do
    @unconfirmed.confirm!
    assert @unconfirmed.confirmed?
    assert_nil @unconfirmed.confirmation_token
  end

  test "generate_confirmation_token! sets new token" do
    old_token = @unconfirmed.confirmation_token
    @unconfirmed.generate_confirmation_token!
    assert_not_equal old_token, @unconfirmed.confirmation_token
    assert @unconfirmed.confirmation_sent_at >= 1.second.ago
  end

  # --- Password Reset (Rails built-in generates_token_for) ---

  test "password_reset_token generates a signed token" do
    token = @account.password_reset_token
    assert token.present?
  end

  test "find_by_token_for resolves account from password reset token" do
    token = @account.password_reset_token
    found = CustomerAccount.find_by_token_for(:password_reset, token)
    assert_equal @account, found
  end

  test "password reset token becomes invalid after password change" do
    token = @account.password_reset_token
    @account.update!(password: "newpassword123", password_confirmation: "newpassword123")
    found = CustomerAccount.find_by_token_for(:password_reset, token)
    assert_nil found
  end

  # --- Sign In Tracking ---

  test "record_sign_in! updates timestamps" do
    @account.record_sign_in!(ip: "192.168.1.1")
    assert @account.last_sign_in_at >= 1.second.ago
    assert_equal "192.168.1.1", @account.last_sign_in_ip
  end

  # --- Slug ---

  test "generates slug from customer name" do
    assert @account.slug.present?
  end

  # --- Before Create ---

  test "generates confirmation token on create" do
    customer = customers(:minor_diver)
    account = CustomerAccount.create!(
      organization: customer.organization,
      customer: customer,
      email: "tommy@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert account.confirmation_token.present?
    assert account.confirmation_sent_at.present?
  end
end
