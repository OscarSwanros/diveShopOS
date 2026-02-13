# frozen_string_literal: true

require "test_helper"

class ChecklistResponseTest < ActiveSupport::TestCase
  test "valid response" do
    response = checklist_responses(:o2_kit_response)
    assert response.valid?
  end

  test "unique per run and item" do
    response = ChecklistResponse.new(
      checklist_run: checklist_runs(:morning_reef_safety),
      checklist_item: checklist_items(:o2_kit)
    )
    assert_not response.valid?
    assert_includes response.errors[:checklist_item_id], "has already been taken"
  end

  test "checked defaults to false" do
    response = ChecklistResponse.new
    assert_equal false, response.checked?
  end

  test "completed_by is optional" do
    response = checklist_responses(:first_aid_response)
    assert_nil response.completed_by
    assert response.valid?
  end

  test "belongs to checklist run" do
    response = checklist_responses(:o2_kit_response)
    assert_equal checklist_runs(:morning_reef_safety), response.checklist_run
  end

  test "belongs to checklist item" do
    response = checklist_responses(:o2_kit_response)
    assert_equal checklist_items(:o2_kit), response.checklist_item
  end
end
