# frozen_string_literal: true

require "test_helper"

class Api::V1::ChecklistTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @template = checklist_templates(:pre_departure_safety)
  end

  test "index returns templates with pagination" do
    get api_v1_checklist_templates_path, headers: api_headers(@token)

    assert_response :success
    assert parsed_response["data"].is_a?(Array)
    assert parsed_response["meta"]["total_count"].positive?
  end

  test "index filters by category" do
    get api_v1_checklist_templates_path(category: "safety"), headers: api_headers(@token)

    assert_response :success
    parsed_response["data"].each do |tpl|
      assert_equal "safety", tpl["category"]
    end
  end

  test "index filters active only" do
    get api_v1_checklist_templates_path(active: "true"), headers: api_headers(@token)

    assert_response :success
    parsed_response["data"].each do |tpl|
      assert_equal true, tpl["active"]
    end
  end

  test "index does not return other org templates" do
    get api_v1_checklist_templates_path, headers: api_headers(@token)

    ids = parsed_response["data"].map { |t| t["id"] }
    refute_includes ids, checklist_templates(:other_org_template).id
  end

  test "show returns template" do
    get api_v1_checklist_template_path(@template), headers: api_headers(@token)

    assert_response :success
    assert_equal @template.id, parsed_response["data"]["id"]
    assert parsed_response["data"].key?("items_count")
  end

  test "create creates template" do
    assert_difference "ChecklistTemplate.count", 1 do
      post api_v1_checklist_templates_path, params: {
        checklist_template: {
          title: "New Safety Check",
          category: "safety",
          description: "A new check"
        }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "create requires manager or owner" do
    staff_token = api_token_for(users(:staff_ana))
    post api_v1_checklist_templates_path, params: {
      checklist_template: { title: "Test", category: "safety" }
    }, headers: api_headers(staff_token), as: :json

    assert_response :forbidden
  end

  test "update updates template" do
    patch api_v1_checklist_template_path(@template), params: {
      checklist_template: { title: "Updated Safety Check" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "Updated Safety Check", parsed_response["data"]["title"]
  end

  test "destroy deletes template without runs" do
    template = checklist_templates(:annual_inspection)
    delete api_v1_checklist_template_path(template), headers: api_headers(@token)
    assert_response :no_content
  end

  test "destroy fails for template with runs" do
    delete api_v1_checklist_template_path(@template), headers: api_headers(@token)
    assert_response :unprocessable_entity
  end

  test "destroy requires owner" do
    manager_token = api_token_for(users(:manager_carlos))
    delete api_v1_checklist_template_path(checklist_templates(:annual_inspection)),
      headers: api_headers(manager_token)

    assert_response :forbidden
  end

  test "unauthenticated request returns 401" do
    get api_v1_checklist_templates_path
    assert_response :unauthorized
  end
end
