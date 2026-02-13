# frozen_string_literal: true

require "test_helper"

class Checklists::StartRunTest < ActiveSupport::TestCase
  test "creates a run from active template" do
    template = checklist_templates(:pre_departure_safety)
    user = users(:owner_maria)

    result = Checklists::StartRun.new(template: template, started_by: user).call

    assert result.success
    assert_nil result.reason
    assert result.checklist_run.persisted?
    assert result.checklist_run.in_progress?
    assert_equal template, result.checklist_run.checklist_template
    assert_equal user, result.checklist_run.started_by
  end

  test "creates responses for all items" do
    template = checklist_templates(:pre_departure_safety)
    user = users(:owner_maria)

    result = Checklists::StartRun.new(template: template, started_by: user).call

    assert_equal template.checklist_items.count, result.checklist_run.checklist_responses.count
    assert result.checklist_run.checklist_responses.all? { |r| !r.checked? }
  end

  test "stores template snapshot" do
    template = checklist_templates(:pre_departure_safety)
    user = users(:owner_maria)

    result = Checklists::StartRun.new(template: template, started_by: user).call

    snapshot = result.checklist_run.template_snapshot
    assert_equal template.title, snapshot["template"]["title"]
    assert_equal template.checklist_items.count, snapshot["items"].size
  end

  test "links to checkable entity" do
    template = checklist_templates(:pre_departure_safety)
    user = users(:owner_maria)
    excursion = excursions(:morning_reef)

    result = Checklists::StartRun.new(
      template: template, started_by: user, checkable: excursion
    ).call

    assert result.success
    assert_equal excursion, result.checklist_run.checkable
  end

  test "fails for inactive template" do
    template = checklist_templates(:inactive_template)
    user = users(:owner_maria)

    result = Checklists::StartRun.new(template: template, started_by: user).call

    assert_not result.success
    assert_includes result.reason, "inactive"
    assert_nil result.checklist_run
  end

  test "fails for template with no items" do
    template = checklist_templates(:annual_inspection)
    user = users(:owner_maria)

    result = Checklists::StartRun.new(template: template, started_by: user).call

    assert_not result.success
    assert_includes result.reason, "no items"
    assert_nil result.checklist_run
  end
end
