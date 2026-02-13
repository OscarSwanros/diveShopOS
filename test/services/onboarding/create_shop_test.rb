# frozen_string_literal: true

require "test_helper"

class Onboarding::CreateShopTest < ActiveSupport::TestCase
  test "creates organization and owner user on success" do
    result = Onboarding::CreateShop.new(
      shop_name: "Sunrise Diving",
      owner_name: "Jane Doe",
      email: "jane@sunrise.com",
      password: "securepassword",
      password_confirmation: "securepassword"
    ).call

    assert result.success
    assert_not_nil result.organization
    assert_not_nil result.user
    assert_nil result.error

    assert_equal "Sunrise Diving", result.organization.name
    assert_equal "sunrise-diving", result.organization.slug
    assert_equal "sunrise-diving", result.organization.subdomain
    assert_equal "en", result.organization.locale
    assert_equal "UTC", result.organization.time_zone

    assert_equal "Jane Doe", result.user.name
    assert_equal "jane@sunrise.com", result.user.email_address
    assert result.user.owner?
    assert_equal result.organization, result.user.organization
  end

  test "generates unique slug when name conflicts" do
    Onboarding::CreateShop.new(
      shop_name: "Reef Divers",
      owner_name: "First Owner",
      email: "first@reef.com",
      password: "password123",
      password_confirmation: "password123"
    ).call

    result = Onboarding::CreateShop.new(
      shop_name: "Reef Divers",
      owner_name: "Second Owner",
      email: "second@reef.com",
      password: "password123",
      password_confirmation: "password123"
    ).call

    assert result.success
    assert_match(/\Areef-divers-\d+\z/, result.organization.slug)
  end

  test "fails when shop name is blank" do
    result = Onboarding::CreateShop.new(
      shop_name: "",
      owner_name: "Jane",
      email: "jane@example.com",
      password: "password",
      password_confirmation: "password"
    ).call

    assert_not result.success
    assert_nil result.organization
    assert_nil result.user
    assert_equal I18n.t("onboarding.registration.errors.fields_required"), result.error
  end

  test "fails when password does not match confirmation" do
    result = Onboarding::CreateShop.new(
      shop_name: "Test Shop",
      owner_name: "Jane",
      email: "jane@example.com",
      password: "password1",
      password_confirmation: "password2"
    ).call

    assert_not result.success
    assert_equal I18n.t("onboarding.registration.errors.password_mismatch"), result.error
  end

  test "fails when email is invalid" do
    result = Onboarding::CreateShop.new(
      shop_name: "Test Shop",
      owner_name: "Jane",
      email: "invalid-email",
      password: "password123",
      password_confirmation: "password123"
    ).call

    assert_not result.success
    assert_not_nil result.error
  end

  test "avoids reserved subdomains" do
    result = Onboarding::CreateShop.new(
      shop_name: "Admin",
      owner_name: "Jane",
      email: "jane@admin.com",
      password: "password123",
      password_confirmation: "password123"
    ).call

    assert result.success
    assert_not_equal "admin", result.organization.slug
  end
end
