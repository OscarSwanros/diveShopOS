# frozen_string_literal: true

require "test_helper"

class Checklists::CompleteRunTest < ActiveSupport::TestCase
  test "completes run when all required items checked" do
    run = checklist_runs(:morning_reef_safety)

    # Check all required items
    run.checklist_responses.joins(:checklist_item).where(checklist_items: { required: true }).each do |resp|
      resp.update!(checked: true, checked_at: Time.current, completed_by: users(:owner_maria))
    end

    result = Checklists::CompleteRun.new(run: run).call

    assert result.success
    run.reload
    assert run.completed?
    assert run.completed_at.present?
  end

  test "completes with exceptions when required items unchecked and notes provided" do
    run = checklist_runs(:morning_reef_safety)

    result = Checklists::CompleteRun.new(
      run: run,
      notes: "O2 kit pressure was borderline but acceptable"
    ).call

    assert result.success
    run.reload
    assert run.completed_with_exceptions?
    assert run.completed_at.present?
    assert_equal "O2 kit pressure was borderline but acceptable", run.notes
  end

  test "fails without notes when required items unchecked" do
    run = checklist_runs(:morning_reef_safety)

    result = Checklists::CompleteRun.new(run: run).call

    assert_not result.success
    assert_includes result.reason, "Notes are required"
  end

  test "fails when run is not in progress" do
    run = checklist_runs(:completed_run)

    result = Checklists::CompleteRun.new(run: run).call

    assert_not result.success
    assert_includes result.reason, "not in progress"
  end

  test "records notes even when all items are checked" do
    run = checklist_runs(:morning_reef_safety)

    run.checklist_responses.joins(:checklist_item).where(checklist_items: { required: true }).each do |resp|
      resp.update!(checked: true, checked_at: Time.current, completed_by: users(:owner_maria))
    end

    result = Checklists::CompleteRun.new(run: run, notes: "All good").call

    assert result.success
    run.reload
    assert run.completed?
    assert_equal "All good", run.notes
  end
end
