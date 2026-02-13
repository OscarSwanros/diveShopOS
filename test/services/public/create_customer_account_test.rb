# frozen_string_literal: true

require "test_helper"

class Public::CreateCustomerAccountTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:reef_divers)
  end

  test "creates new customer and account for new email" do
    result = Public::CreateCustomerAccount.new(
      organization: @organization,
      email: "newcomer@example.com",
      password: "password123",
      password_confirmation: "password123",
      first_name: "New",
      last_name: "Diver"
    ).call

    assert result.success
    assert result.customer_account.persisted?
    assert_equal "newcomer@example.com", result.customer_account.email
    assert_equal "New", result.customer_account.customer.first_name
    assert_equal @organization, result.customer_account.organization
  end

  test "links to existing customer without account" do
    customer = customers(:minor_diver)
    customer.update!(email: "tommy@example.com")

    result = Public::CreateCustomerAccount.new(
      organization: @organization,
      email: "tommy@example.com",
      password: "password123",
      password_confirmation: "password123",
      first_name: "Tommy",
      last_name: "Young"
    ).call

    assert result.success
    assert_equal customer, result.customer_account.customer
  end

  test "rejects when customer already has an account" do
    result = Public::CreateCustomerAccount.new(
      organization: @organization,
      email: "jane@example.com",
      password: "password123",
      password_confirmation: "password123",
      first_name: "Jane",
      last_name: "Diver"
    ).call

    assert_not result.success
    assert_includes result.error, I18n.t("public.registrations.already_registered")
  end

  test "rejects with password mismatch" do
    result = Public::CreateCustomerAccount.new(
      organization: @organization,
      email: "new@example.com",
      password: "password123",
      password_confirmation: "wrongpass",
      first_name: "New",
      last_name: "Diver"
    ).call

    assert_not result.success
  end

  test "generates confirmation token on creation" do
    result = Public::CreateCustomerAccount.new(
      organization: @organization,
      email: "newcomer@example.com",
      password: "password123",
      password_confirmation: "password123",
      first_name: "New",
      last_name: "Diver"
    ).call

    assert result.success
    assert result.customer_account.confirmation_token.present?
  end
end
