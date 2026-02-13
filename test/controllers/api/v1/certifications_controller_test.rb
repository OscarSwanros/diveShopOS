# frozen_string_literal: true

require "test_helper"

class Api::V1::CertificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @customer = customers(:jane_diver)
    @certification = certifications(:jane_ow)
  end

  test "index returns certifications for customer" do
    get api_v1_customer_certifications_path(@customer), headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
    # Discarded certs should not appear
    ids = parsed_response["data"].map { |c| c["id"] }
    refute_includes ids, certifications(:discarded_cert).id
  end

  test "show returns certification" do
    get api_v1_customer_certification_path(@customer, @certification), headers: api_headers(@token)

    assert_response :success
    assert_equal @certification.id, parsed_response["data"]["id"]
  end

  test "create creates certification" do
    assert_difference "Certification.count", 1 do
      post api_v1_customer_certifications_path(@customer), params: {
        certification: { agency: "NAUI", certification_level: "Advanced" }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "update updates certification" do
    patch api_v1_customer_certification_path(@customer, @certification), params: {
      certification: { certification_number: "NEW-999" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "NEW-999", parsed_response["data"]["certification_number"]
  end

  test "destroy soft-deletes certification" do
    delete api_v1_customer_certification_path(@customer, @certification), headers: api_headers(@token)

    assert_response :no_content
    assert @certification.reload.discarded?
  end

  test "requires authentication" do
    get api_v1_customer_certifications_path(@customer)
    assert_response :unauthorized
  end
end
