# frozen_string_literal: true

require "test_helper"

class Checklists::CheckExcursionReadinessTest < ActiveSupport::TestCase
  test "succeeds when no safety checklists are in progress" do
    excursion = excursions(:draft_trip)

    result = Checklists::CheckExcursionReadiness.new(excursion: excursion).call

    assert result.success
    assert_nil result.reason
  end

  test "fails when safety checklist is in progress" do
    excursion = excursions(:morning_reef)

    result = Checklists::CheckExcursionReadiness.new(excursion: excursion).call

    assert_not result.success
    assert_includes result.reason, "Pre-Departure Safety Check"
  end

  test "succeeds when only operational checklists are in progress" do
    excursion = excursions(:draft_trip)
    # Create an operational checklist run
    organizations(:reef_divers).checklist_runs.create!(
      checklist_template: checklist_templates(:shop_open),
      started_by: users(:owner_maria),
      checkable: excursion,
      template_snapshot: {}
    )

    result = Checklists::CheckExcursionReadiness.new(excursion: excursion).call

    assert result.success
  end

  test "succeeds when safety checklist is completed" do
    # The morning_reef excursion has an in-progress safety run; complete it
    run = checklist_runs(:morning_reef_safety)
    run.update!(status: :completed, completed_at: Time.current)

    excursion = excursions(:morning_reef)
    result = Checklists::CheckExcursionReadiness.new(excursion: excursion).call

    assert result.success
  end
end
