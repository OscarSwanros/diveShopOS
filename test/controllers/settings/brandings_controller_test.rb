# frozen_string_literal: true

require "test_helper"

class Settings::BrandingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = users(:owner_maria)
    @manager = users(:manager_carlos)
    @staff = users(:staff_ana)
    @organization = organizations(:reef_divers)
  end

  # --- Authentication ---

  test "requires authentication" do
    get settings_branding_path
    assert_redirected_to new_session_path
  end

  # --- Authorization ---

  test "owner can access branding settings" do
    sign_in @owner
    get settings_branding_path
    assert_response :success
  end

  test "manager cannot access branding settings" do
    sign_in @manager
    get settings_branding_path
    assert_response :forbidden
  end

  test "staff cannot access branding settings" do
    sign_in @staff
    get settings_branding_path
    assert_response :forbidden
  end

  # --- Show ---

  test "show displays color picker fields" do
    sign_in @owner
    get settings_branding_path
    assert_select "input[name='organization[brand_primary_color]']"
    assert_select "input[name='organization[brand_accent_color]']"
  end

  test "show displays tagline field" do
    sign_in @owner
    get settings_branding_path
    assert_select "input[name='organization[tagline]']"
  end

  test "show displays social links fields" do
    sign_in @owner
    get settings_branding_path
    assert_select "input[name='organization[social_links][facebook]']"
    assert_select "input[name='organization[social_links][instagram]']"
    assert_select "input[name='organization[social_links][youtube]']"
  end

  # --- Update ---

  test "owner can update brand colors" do
    sign_in @owner
    patch settings_branding_path, params: {
      organization: { brand_primary_color: "#1a73e8", brand_accent_color: "#059669" }
    }
    assert_redirected_to settings_branding_path
    @organization.reload
    assert_equal "#1a73e8", @organization.brand_primary_color
    assert_equal "#059669", @organization.brand_accent_color
  end

  test "owner can update tagline and contact info" do
    sign_in @owner
    patch settings_branding_path, params: {
      organization: {
        tagline: "Dive into adventure",
        phone: "+1-555-0100",
        contact_email: "info@reefdive.com",
        address: "123 Ocean Drive"
      }
    }
    assert_redirected_to settings_branding_path
    @organization.reload
    assert_equal "Dive into adventure", @organization.tagline
    assert_equal "+1-555-0100", @organization.phone
    assert_equal "info@reefdive.com", @organization.contact_email
    assert_equal "123 Ocean Drive", @organization.address
  end

  test "owner can update social links" do
    sign_in @owner
    patch settings_branding_path, params: {
      organization: {
        social_links: {
          facebook: "https://facebook.com/reefdive",
          instagram: "https://instagram.com/reefdive",
          youtube: ""
        }
      }
    }
    assert_redirected_to settings_branding_path
    @organization.reload
    assert_equal "https://facebook.com/reefdive", @organization.social_links["facebook"]
    assert_equal "https://instagram.com/reefdive", @organization.social_links["instagram"]
  end

  test "rejects invalid hex color format" do
    sign_in @owner
    patch settings_branding_path, params: {
      organization: { brand_primary_color: "not-a-color" }
    }
    assert_response :unprocessable_entity
  end

  test "rejects invalid contact email format" do
    sign_in @owner
    patch settings_branding_path, params: {
      organization: { contact_email: "not-an-email" }
    }
    assert_response :unprocessable_entity
  end

  test "allows blank brand colors" do
    sign_in @owner
    @organization.update!(brand_primary_color: "#1a73e8")
    patch settings_branding_path, params: {
      organization: { brand_primary_color: "" }
    }
    assert_redirected_to settings_branding_path
    assert_nil @organization.reload.brand_primary_color
  end

  private

  def sign_in(user)
    post session_path, params: { email_address: user.email_address, password: "password123" }
  end
end
