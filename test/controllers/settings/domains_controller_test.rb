# frozen_string_literal: true

require "test_helper"

class Settings::DomainsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = users(:owner_maria)
    @manager = users(:manager_carlos)
    @staff = users(:staff_ana)
    @organization = organizations(:reef_divers)
  end

  # --- Authentication ---

  test "requires authentication" do
    get settings_domain_path
    assert_redirected_to new_session_path
  end

  # --- Authorization ---

  test "owner can access domain settings" do
    sign_in @owner
    get settings_domain_path
    assert_response :success
  end

  test "manager cannot access domain settings" do
    sign_in @manager
    assert_raises(Pundit::NotAuthorizedError) do
      get settings_domain_path
    end
  end

  test "staff cannot access domain settings" do
    sign_in @staff
    assert_raises(Pundit::NotAuthorizedError) do
      get settings_domain_path
    end
  end

  # --- Show ---

  test "show displays current subdomain" do
    sign_in @owner
    get settings_domain_path
    assert_select "span", text: /#{@organization.subdomain}/
  end

  test "show displays custom domain form" do
    sign_in @owner
    get settings_domain_path
    assert_select "input[name='organization[custom_domain]']"
  end

  test "show displays DNS instructions when custom domain is set" do
    sign_in @owner
    get settings_domain_path
    assert_select "h2", text: I18n.t("settings.domain.dns.title")
  end

  # --- Update ---

  test "owner can update custom domain" do
    sign_in @owner
    patch settings_domain_path, params: { organization: { custom_domain: "www.newdomain.com" } }
    assert_redirected_to settings_domain_path
    assert_equal "www.newdomain.com", @organization.reload.custom_domain
  end

  test "update normalizes domain input" do
    sign_in @owner
    patch settings_domain_path, params: { organization: { custom_domain: "HTTPS://WWW.MyShop.COM/page" } }
    assert_redirected_to settings_domain_path
    assert_equal "www.myshop.com", @organization.reload.custom_domain
  end

  test "update strips ports from domain" do
    sign_in @owner
    patch settings_domain_path, params: { organization: { custom_domain: "www.myshop.com:8080" } }
    assert_redirected_to settings_domain_path
    assert_equal "www.myshop.com", @organization.reload.custom_domain
  end

  test "update rejects invalid domain format" do
    sign_in @owner
    patch settings_domain_path, params: { organization: { custom_domain: "not a domain" } }
    assert_response :unprocessable_entity
  end

  test "clearing custom domain sets it to nil" do
    sign_in @owner
    patch settings_domain_path, params: { organization: { custom_domain: "" } }
    assert_redirected_to settings_domain_path
    assert_nil @organization.reload.custom_domain
  end

  # --- Verify ---

  test "verify responds with turbo stream" do
    sign_in @owner
    post verify_settings_domain_path, headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_includes response.content_type, "text/vnd.turbo-stream.html"
  end

  test "verify redirects for HTML requests" do
    sign_in @owner
    post verify_settings_domain_path
    assert_redirected_to settings_domain_path
  end

  private

  def sign_in(user)
    post session_path, params: { email_address: user.email_address, password: "password123" }
  end
end
