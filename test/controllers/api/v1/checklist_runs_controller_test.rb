# frozen_string_literal: true

require "test_helper"

class Api::V1::ChecklistRunsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @run = checklist_runs(:morning_reef_safety)
    @template = checklist_templates(:pre_departure_safety)
  end

  test "index returns runs with pagination" do
    get api_v1_checklist_runs_path, headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
    assert parsed_response["meta"]["total_count"].positive?
  end

  test "index filters by status" do
    get api_v1_checklist_runs_path(status: "in_progress"), headers: api_headers(@token)

    assert_response :success
    parsed_response["data"].each do |run|
      assert_equal "in_progress", run["status"]
    end
  end

  test "show returns run with progress" do
    get api_v1_checklist_run_path(@run), headers: api_headers(@token)

    assert_response :success
    assert_equal @run.id, parsed_response["data"]["id"]
    assert parsed_response["data"]["progress"].key?("checked")
    assert parsed_response["data"]["progress"].key?("total")
    assert parsed_response["data"]["progress"].key?("percentage")
  end

  test "create starts a run" do
    template = checklist_templates(:shop_open)

    assert_difference "ChecklistRun.count", 1 do
      post api_v1_checklist_runs_path, params: {
        checklist_template_id: template.slug
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
    assert_equal "in_progress", parsed_response["data"]["status"]
  end

  test "create with checkable" do
    template = checklist_templates(:shop_open)
    excursion = excursions(:morning_reef)

    post api_v1_checklist_runs_path, params: {
      checklist_template_id: template.slug,
      checkable_type: "Excursion",
      checkable_id: excursion.id
    }, headers: api_headers(@token), as: :json

    assert_response :created
    assert_equal "Excursion", parsed_response["data"]["checkable_type"]
  end

  test "create fails for inactive template" do
    template = checklist_templates(:inactive_template)

    post api_v1_checklist_runs_path, params: {
      checklist_template_id: template.slug
    }, headers: api_headers(@token), as: :json

    assert_response :unprocessable_entity
  end

  test "complete transitions to completed" do
    # Check all required items first
    @run.checklist_responses.joins(:checklist_item)
      .where(checklist_items: { required: true }).each do |resp|
      resp.update!(checked: true, checked_at: Time.current, completed_by: @user)
    end

    post complete_api_v1_checklist_run_path(@run), headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "completed", parsed_response["data"]["status"]
  end

  test "complete with exceptions requires notes" do
    post complete_api_v1_checklist_run_path(@run), headers: api_headers(@token), as: :json

    assert_response :unprocessable_entity
  end

  test "complete with exceptions and notes" do
    post complete_api_v1_checklist_run_path(@run), params: {
      notes: "O2 pressure slightly below threshold"
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "completed_with_exceptions", parsed_response["data"]["status"]
  end

  test "abandon with notes" do
    post abandon_api_v1_checklist_run_path(@run), params: {
      notes: "Trip cancelled"
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "abandoned", parsed_response["data"]["status"]
  end

  test "abandon without notes fails" do
    post abandon_api_v1_checklist_run_path(@run), headers: api_headers(@token), as: :json

    assert_response :unprocessable_entity
  end

  test "destroy deletes run" do
    delete api_v1_checklist_run_path(@run), headers: api_headers(@token)
    assert_response :no_content
  end
end
