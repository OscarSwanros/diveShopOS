# frozen_string_literal: true

require "test_helper"

class Onboarding::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "GET /start renders signup form" do
    get onboarding_start_path
    assert_response :success
  end

  test "POST /start creates organization and user" do
    assert_difference "Organization.count", 1 do
      post onboarding_start_path, params: {
        shop_name: "Pacific Divers",
        owner_name: "Jane Doe",
        email: "jane@pacific.com",
        password: "password123",
        password_confirmation: "password123"
      }
    end

    org = Organization.find_by(name: "Pacific Divers")
    assert_not_nil org
    assert_equal "pacific-divers", org.slug

    owner = org.users.find_by(role: :owner)
    assert_not_nil owner
    assert_equal "Jane Doe", owner.name

    assert_redirected_to root_url(host: "#{org.subdomain}.lvh.me")
  end

  test "POST /start seeds demo data" do
    post onboarding_start_path, params: {
      shop_name: "Demo Divers",
      owner_name: "Jane Demo",
      email: "demo@divers.com",
      password: "password123",
      password_confirmation: "password123"
    }

    org = Organization.find_by(name: "Demo Divers")
    assert org.dive_sites.any?, "Should have demo dive sites"
    assert org.customers.any?, "Should have demo customers"
    assert org.excursions.any?, "Should have demo excursions"
  end

  test "POST /start with invalid data re-renders form" do
    assert_no_difference "Organization.count" do
      post onboarding_start_path, params: {
        shop_name: "",
        owner_name: "Jane",
        email: "jane@test.com",
        password: "password",
        password_confirmation: "password"
      }
    end

    assert_response :unprocessable_entity
  end

  test "POST /start with password mismatch re-renders form" do
    assert_no_difference "Organization.count" do
      post onboarding_start_path, params: {
        shop_name: "Test Shop",
        owner_name: "Jane",
        email: "jane@test.com",
        password: "password1",
        password_confirmation: "password2"
      }
    end

    assert_response :unprocessable_entity
  end

  test "GET /start redirects when already signed in" do
    sign_in users(:owner_maria)
    get onboarding_start_path
    assert_redirected_to root_path
  end

  private

  def sign_in(user)
    post session_path, params: { email_address: user.email_address, password: "password123" }
  end
end
