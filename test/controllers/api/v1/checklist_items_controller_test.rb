# frozen_string_literal: true

require "test_helper"

class Api::V1::ChecklistItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:owner_maria)
    @token = api_token_for(@user)
    @template = checklist_templates(:pre_departure_safety)
    @item = checklist_items(:o2_kit)
  end

  test "index returns items ordered by position" do
    get api_v1_checklist_template_checklist_items_path(@template), headers: api_headers(@token)

    assert_response :success
    data = parsed_response["data"]
    assert_equal @template.checklist_items.count, data.size
    positions = data.map { |i| i["position"] }
    assert_equal positions.sort, positions
  end

  test "show returns item" do
    get api_v1_checklist_template_checklist_item_path(@template, @item), headers: api_headers(@token)

    assert_response :success
    assert_equal @item.id, parsed_response["data"]["id"]
  end

  test "create creates item" do
    assert_difference "ChecklistItem.count", 1 do
      post api_v1_checklist_template_checklist_items_path(@template), params: {
        checklist_item: {
          title: "Emergency plan reviewed",
          position: 10,
          required: true
        }
      }, headers: api_headers(@token), as: :json
    end

    assert_response :created
  end

  test "create requires manager or owner" do
    staff_token = api_token_for(users(:staff_ana))
    post api_v1_checklist_template_checklist_items_path(@template), params: {
      checklist_item: { title: "Test", position: 99 }
    }, headers: api_headers(staff_token), as: :json

    assert_response :forbidden
  end

  test "update updates item" do
    patch api_v1_checklist_template_checklist_item_path(@template, @item), params: {
      checklist_item: { title: "O2 kit onboard and verified" }
    }, headers: api_headers(@token), as: :json

    assert_response :success
    assert_equal "O2 kit onboard and verified", parsed_response["data"]["title"]
  end

  test "destroy deletes item" do
    delete api_v1_checklist_template_checklist_item_path(@template, @item),
      headers: api_headers(@token)

    assert_response :no_content
  end
end
