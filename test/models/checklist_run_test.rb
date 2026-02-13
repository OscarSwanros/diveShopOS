# frozen_string_literal: true

require "test_helper"

class ChecklistRunTest < ActiveSupport::TestCase
  test "valid run" do
    run = checklist_runs(:morning_reef_safety)
    assert run.valid?
  end

  test "requires status" do
    run = ChecklistRun.new(
      organization: organizations(:reef_divers),
      checklist_template: checklist_templates(:pre_departure_safety),
      started_by: users(:owner_maria),
      template_snapshot: {}
    )
    # status defaults to in_progress (0)
    assert run.valid?
  end

  test "status enum" do
    assert checklist_runs(:morning_reef_safety).in_progress?
    assert checklist_runs(:completed_run).completed?
    assert checklist_runs(:abandoned_run).abandoned?
  end

  test "active scope" do
    active = organizations(:reef_divers).checklist_runs.active
    assert_includes active, checklist_runs(:morning_reef_safety)
    assert_not_includes active, checklist_runs(:completed_run)
  end

  test "finished scope" do
    finished = organizations(:reef_divers).checklist_runs.finished
    assert_includes finished, checklist_runs(:completed_run)
    assert_not_includes finished, checklist_runs(:morning_reef_safety)
    assert_not_includes finished, checklist_runs(:abandoned_run)
  end

  test "progress returns correct counts" do
    run = checklist_runs(:morning_reef_safety)
    progress = run.progress
    assert_equal 1, progress[:checked]
    assert_equal 5, progress[:total]
    assert_equal 20, progress[:percentage]
  end

  test "progress handles empty run" do
    run = checklist_runs(:completed_run)
    progress = run.progress
    assert_equal 0, progress[:checked]
    assert_equal 0, progress[:total]
    assert_equal 0, progress[:percentage]
  end

  test "all_required_checked? returns false when required items unchecked" do
    run = checklist_runs(:morning_reef_safety)
    assert_not run.all_required_checked?
  end

  test "polymorphic association to excursion" do
    run = checklist_runs(:morning_reef_safety)
    assert_equal excursions(:morning_reef), run.checkable
  end

  test "belongs to started_by user" do
    run = checklist_runs(:morning_reef_safety)
    assert_equal users(:owner_maria), run.started_by
  end

  test "has many checklist responses" do
    run = checklist_runs(:morning_reef_safety)
    assert_equal 5, run.checklist_responses.count
  end

  test "generates slug" do
    run = organizations(:reef_divers).checklist_runs.create!(
      checklist_template: checklist_templates(:shop_open),
      started_by: users(:owner_maria),
      template_snapshot: {}
    )
    assert run.slug.present?
  end
end
