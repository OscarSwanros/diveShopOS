# frozen_string_literal: true

require "test_helper"

class Checklists::AbandonRunTest < ActiveSupport::TestCase
  test "abandons run with notes" do
    run = checklist_runs(:morning_reef_safety)

    result = Checklists::AbandonRun.new(
      run: run,
      notes: "Trip cancelled due to weather"
    ).call

    assert result.success
    run.reload
    assert run.abandoned?
    assert_equal "Trip cancelled due to weather", run.notes
  end

  test "fails without notes" do
    run = checklist_runs(:morning_reef_safety)

    result = Checklists::AbandonRun.new(run: run).call

    assert_not result.success
    assert_includes result.reason, "Notes are required"
  end

  test "fails with blank notes" do
    run = checklist_runs(:morning_reef_safety)

    result = Checklists::AbandonRun.new(run: run, notes: "").call

    assert_not result.success
    assert_includes result.reason, "Notes are required"
  end

  test "fails when run is not in progress" do
    run = checklist_runs(:completed_run)

    result = Checklists::AbandonRun.new(
      run: run, notes: "Already done"
    ).call

    assert_not result.success
    assert_includes result.reason, "not in progress"
  end
end
