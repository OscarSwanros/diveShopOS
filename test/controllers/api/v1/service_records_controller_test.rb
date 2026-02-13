# frozen_string_literal: true

require "test_helper"

class Api::V1::ServiceRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @item = equipment_items(:bcd_medium)
    @record = service_records(:bcd_annual)
  end

  test "index returns service records for equipment item" do
    get api_v1_equipment_item_service_records_path(@item), headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
  end

  test "show returns service record" do
    get api_v1_equipment_item_service_record_path(@item, @record), headers: api_headers(@token)

    assert_response :success
    assert_equal @record.id, parsed_response["data"]["id"]
  end

  test "create creates service record" do
    assert_difference "ServiceRecord.count", 1 do
      post api_v1_equipment_item_service_records_path(@item), params: {
        service_record: {
          service_type: "annual_service",
          service_date: Date.current.to_s,
          next_due_date: (Date.current + 1.year).to_s,
          performed_by: "Test Tech"
        }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "update updates service record" do
    patch api_v1_equipment_item_service_record_path(@item, @record), params: {
      service_record: { performed_by: "Updated Tech" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "Updated Tech", parsed_response["data"]["performed_by"]
  end

  test "destroy deletes service record" do
    assert_difference "ServiceRecord.count", -1 do
      delete api_v1_equipment_item_service_record_path(@item, @record), headers: api_headers(@token)
    end

    assert_response :no_content
  end

  test "requires authentication" do
    get api_v1_equipment_item_service_records_path(@item)
    assert_response :unauthorized
  end
end
