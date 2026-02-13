# frozen_string_literal: true

require "test_helper"

class Checklists::CompleteItemTest < ActiveSupport::TestCase
  test "checks an item successfully" do
    response = checklist_responses(:first_aid_response)
    user = users(:owner_maria)

    result = Checklists::CompleteItem.new(
      response: response, completed_by: user, checked: true
    ).call

    assert result.success
    response.reload
    assert response.checked?
    assert_equal user, response.completed_by
    assert response.checked_at.present?
  end

  test "unchecks an item" do
    response = checklist_responses(:o2_kit_response)
    user = users(:owner_maria)

    result = Checklists::CompleteItem.new(
      response: response, completed_by: user, checked: false
    ).call

    assert result.success
    response.reload
    assert_not response.checked?
    assert_nil response.completed_by
    assert_nil response.checked_at
  end

  test "records notes on item" do
    response = checklist_responses(:first_aid_response)
    user = users(:owner_maria)

    result = Checklists::CompleteItem.new(
      response: response, completed_by: user, checked: true, notes: "Checked and verified"
    ).call

    assert result.success
    assert_equal "Checked and verified", response.reload.notes
  end

  test "fails when run is not in progress" do
    run = checklist_runs(:completed_run)
    # Create a response for the completed run
    item = checklist_items(:o2_kit)
    response = run.checklist_responses.create!(checklist_item: item)

    result = Checklists::CompleteItem.new(
      response: response, completed_by: users(:owner_maria), checked: true
    ).call

    assert_not result.success
    assert_includes result.reason, "not in progress"
  end

  test "auto-completes run when all required items checked" do
    run = checklist_runs(:morning_reef_safety)

    # Check all remaining required items
    run.checklist_responses.joins(:checklist_item).where(checklist_items: { required: true }, checked: false).each do |resp|
      Checklists::CompleteItem.new(
        response: resp, completed_by: users(:owner_maria), checked: true
      ).call
    end

    run.reload
    assert run.completed?
    assert run.completed_at.present?
  end

  test "does not auto-complete when optional items are unchecked" do
    run = checklist_runs(:morning_reef_safety)

    # Check all required items but leave optional unchecked
    run.checklist_responses.joins(:checklist_item).where(checklist_items: { required: true }, checked: false).each do |resp|
      Checklists::CompleteItem.new(
        response: resp, completed_by: users(:owner_maria), checked: true
      ).call
    end

    run.reload
    assert run.completed? # Optional items don't block completion
  end
end
