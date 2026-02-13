# frozen_string_literal: true

require "test_helper"

class Api::V1::MedicalRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @customer = customers(:jane_diver)
    @medical_record = medical_records(:jane_cleared)
  end

  test "index returns medical records for customer" do
    get api_v1_customer_medical_records_path(@customer), headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
    ids = parsed_response["data"].map { |m| m["id"] }
    refute_includes ids, medical_records(:discarded_medical).id
  end

  test "index requires manager or owner" do
    staff_token = api_token_for(users(:staff_ana))
    get api_v1_customer_medical_records_path(@customer), headers: api_headers(staff_token)

    assert_response :forbidden
  end

  test "show returns medical record" do
    get api_v1_customer_medical_record_path(@customer, @medical_record), headers: api_headers(@token)

    assert_response :success
    assert_equal @medical_record.id, parsed_response["data"]["id"]
  end

  test "create creates medical record" do
    assert_difference "MedicalRecord.count", 1 do
      post api_v1_customer_medical_records_path(@customer), params: {
        medical_record: { status: "cleared", clearance_date: Date.current, physician_name: "Dr. Test" }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "update updates medical record" do
    patch api_v1_customer_medical_record_path(@customer, @medical_record), params: {
      medical_record: { physician_name: "Dr. Updated" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "Dr. Updated", parsed_response["data"]["physician_name"]
  end

  test "destroy soft-deletes medical record" do
    delete api_v1_customer_medical_record_path(@customer, @medical_record), headers: api_headers(@token)

    assert_response :no_content
    assert @medical_record.reload.discarded?
  end
end
