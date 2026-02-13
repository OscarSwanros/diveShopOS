# frozen_string_literal: true

require "test_helper"

class Api::V1::ChecklistResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @run = checklist_runs(:morning_reef_safety)
    @checklist_response = checklist_responses(:first_aid_response)
  end

  test "index returns responses ordered by item position" do
    get api_v1_checklist_run_checklist_responses_path(@run), headers: api_headers(@token)

    assert_response :success
    assert_equal @run.checklist_responses.count, parsed_response["data"].size
  end

  test "show returns response" do
    get api_v1_checklist_run_checklist_response_path(@run, @checklist_response), headers: api_headers(@token)

    assert_response :success
    assert_equal @checklist_response.id, parsed_response["data"]["id"]
  end

  test "update checks an item" do
    patch api_v1_checklist_run_checklist_response_path(@run, @checklist_response), params: {
      checked: true,
      notes: "Verified OK"
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal true, parsed_response["data"]["checked"]
    assert_equal "Verified OK", parsed_response["data"]["notes"]
  end

  test "update unchecks an item" do
    checked_response = checklist_responses(:o2_kit_response)

    patch api_v1_checklist_run_checklist_response_path(@run, checked_response), params: {
      checked: false
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal false, parsed_response["data"]["checked"]
  end

  test "update fails when run is not in progress" do
    completed_run = checklist_runs(:completed_run)
    item = checklist_items(:o2_kit)
    checklist_resp = completed_run.checklist_responses.create!(checklist_item: item)

    patch api_v1_checklist_run_checklist_response_path(completed_run, checklist_resp), params: {
      checked: true
    }, headers: api_headers(@token), as: :json

    assert_response :unprocessable_entity
  end
end
