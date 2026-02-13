# frozen_string_literal: true

require "test_helper"

class Public::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
  end

  test "new renders signup form" do
    get public_signup_path
    assert_response :success
    assert_select "h1", text: I18n.t("public.registrations.title")
  end

  test "create registers new customer" do
    assert_difference [ "CustomerAccount.count", "Customer.count" ], 1 do
      post public_signup_path, params: {
        first_name: "New",
        last_name: "Diver",
        email: "newdiver@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    end
    assert_redirected_to public_confirmation_pending_path(email: "newdiver@example.com")
  end

  test "create sends confirmation email" do
    assert_enqueued_emails 1 do
      post public_signup_path, params: {
        first_name: "New",
        last_name: "Diver",
        email: "newdiver@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    end
  end

  test "create rejects duplicate email" do
    assert_no_difference "CustomerAccount.count" do
      post public_signup_path, params: {
        first_name: "Jane",
        last_name: "Diver",
        email: "jane@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    end
    assert_response :unprocessable_entity
  end

  test "create rejects password mismatch" do
    assert_no_difference "CustomerAccount.count" do
      post public_signup_path, params: {
        first_name: "New",
        last_name: "Diver",
        email: "newdiver@example.com",
        password: "password123",
        password_confirmation: "wrongpass"
      }
    end
    assert_response :unprocessable_entity
  end
end
