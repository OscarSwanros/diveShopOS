# frozen_string_literal: true

require "test_helper"

class Public::ProfileControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @jane_account = customer_accounts(:jane_account)
    @jane = customers(:jane_diver)
  end

  def sign_in_customer(account)
    post public_login_path, params: { email: account.email, password: "password123" }
  end

  # --- Authentication ---

  test "show redirects unauthenticated customer to login" do
    get my_profile_path
    assert_redirected_to public_login_path
  end

  test "edit redirects unauthenticated customer to login" do
    get edit_my_profile_path
    assert_redirected_to public_login_path
  end

  test "update redirects unauthenticated customer to login" do
    patch my_profile_path, params: { customer: { first_name: "Updated" } }
    assert_redirected_to public_login_path
  end

  # --- Show ---

  test "show renders profile for authenticated customer" do
    sign_in_customer(@jane_account)
    get my_profile_path
    assert_response :success
    assert_select "p", text: @jane.first_name
    assert_select "p", text: @jane.last_name
    assert_select "p", text: @jane.phone
  end

  # --- Edit ---

  test "edit renders form for authenticated customer" do
    sign_in_customer(@jane_account)
    get edit_my_profile_path
    assert_response :success
    assert_select "form"
    assert_select "input[name='customer[first_name]'][value='#{@jane.first_name}']"
  end

  # --- Update ---

  test "update updates customer profile" do
    sign_in_customer(@jane_account)
    patch my_profile_path, params: {
      customer: {
        first_name: "Janet",
        last_name: "Diver",
        phone: "+1-555-9999",
        emergency_contact_name: "Bob Diver",
        emergency_contact_phone: "+1-555-8888"
      }
    }
    assert_redirected_to my_profile_path
    @jane.reload
    assert_equal "Janet", @jane.first_name
    assert_equal "+1-555-9999", @jane.phone
    assert_equal "Bob Diver", @jane.emergency_contact_name
    assert_equal "+1-555-8888", @jane.emergency_contact_phone
  end

  test "update does not allow changing email" do
    sign_in_customer(@jane_account)
    original_email = @jane.email
    patch my_profile_path, params: {
      customer: { email: "hacker@evil.com" }
    }
    @jane.reload
    assert_equal original_email, @jane.email
  end

  test "update re-renders form on validation error" do
    sign_in_customer(@jane_account)
    patch my_profile_path, params: {
      customer: { first_name: "" }
    }
    assert_response :unprocessable_entity
    assert_select "form"
  end

  test "update allows changing date of birth" do
    sign_in_customer(@jane_account)
    patch my_profile_path, params: {
      customer: { date_of_birth: "1991-06-20" }
    }
    assert_redirected_to my_profile_path
    @jane.reload
    assert_equal Date.new(1991, 6, 20), @jane.date_of_birth
  end
end
