# frozen_string_literal: true

require "test_helper"

class Public::CertificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @jane_account = customer_accounts(:jane_account)
    @jane = customers(:jane_diver)
  end

  def sign_in_customer(account)
    post public_login_path, params: { email: account.email, password: "password123" }
  end

  # --- Authentication ---

  test "index redirects unauthenticated customer to login" do
    get my_certifications_path
    assert_redirected_to public_login_path
  end

  test "new redirects unauthenticated customer to login" do
    get new_my_certification_path
    assert_redirected_to public_login_path
  end

  test "create redirects unauthenticated customer to login" do
    post my_certifications_path, params: { certification: { agency: "PADI" } }
    assert_redirected_to public_login_path
  end

  # --- Index ---

  test "index renders certifications for authenticated customer" do
    sign_in_customer(@jane_account)
    get my_certifications_path
    assert_response :success
    assert_select "p.font-medium", text: "Open Water"
    assert_select "p.font-medium", text: "Advanced Open Water"
  end

  test "index does not show discarded certifications" do
    sign_in_customer(@jane_account)
    get my_certifications_path
    assert_select "p.font-medium", text: "Intro to Scuba", count: 0
  end

  # --- New ---

  test "new renders certification form" do
    sign_in_customer(@jane_account)
    get new_my_certification_path
    assert_response :success
    assert_select "form"
    assert_select "input[name='certification[agency]']"
    assert_select "input[name='certification[certification_level]']"
  end

  # --- Create ---

  test "create adds certification for customer" do
    sign_in_customer(@jane_account)

    assert_difference "Certification.count", 1 do
      post my_certifications_path, params: {
        certification: {
          agency: "SSI",
          certification_level: "Rescue Diver",
          certification_number: "SSI-12345",
          issued_date: "2024-08-15"
        }
      }
    end

    assert_redirected_to my_certifications_path
    cert = @jane.certifications.order(created_at: :desc).first
    assert_equal "SSI", cert.agency
    assert_equal "Rescue Diver", cert.certification_level
    assert_equal "SSI-12345", cert.certification_number
    assert_equal Date.new(2024, 8, 15), cert.issued_date
  end

  test "create re-renders form on validation error" do
    sign_in_customer(@jane_account)

    assert_no_difference "Certification.count" do
      post my_certifications_path, params: {
        certification: {
          agency: "",
          certification_level: ""
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "form"
  end

  test "create does not allow setting customer_id for another customer" do
    sign_in_customer(@jane_account)
    other_customer = customers(:bob_bubbles)

    post my_certifications_path, params: {
      certification: {
        agency: "PADI",
        certification_level: "Divemaster",
        customer_id: other_customer.id
      }
    }

    # Should create cert for Jane, not Bob
    cert = Certification.order(created_at: :desc).first
    assert_equal @jane.id, cert.customer_id
  end
end
