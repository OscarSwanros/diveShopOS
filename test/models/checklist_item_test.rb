# frozen_string_literal: true

require "test_helper"

class ChecklistItemTest < ActiveSupport::TestCase
  test "valid item" do
    item = checklist_items(:o2_kit)
    assert item.valid?
  end

  test "requires title" do
    item = ChecklistItem.new(
      checklist_template: checklist_templates(:pre_departure_safety),
      position: 10
    )
    assert_not item.valid?
    assert_includes item.errors[:title], "can't be blank"
  end

  test "requires position" do
    item = ChecklistItem.new(
      checklist_template: checklist_templates(:pre_departure_safety),
      title: "Test"
    )
    assert_not item.valid?
    assert_includes item.errors[:position], "can't be blank"
  end

  test "position must be non-negative integer" do
    item = checklist_items(:o2_kit)

    item.position = -1
    assert_not item.valid?

    item.position = 0
    assert item.valid?
  end

  test "ordered scope" do
    items = checklist_templates(:pre_departure_safety).checklist_items.ordered
    positions = items.map(&:position)
    assert_equal positions.sort, positions
  end

  test "required_items scope" do
    required = checklist_templates(:pre_departure_safety).checklist_items.required_items
    assert required.all?(&:required?)
    assert_not_includes required, checklist_items(:sunscreen_optional)
  end

  test "default required is true" do
    item = ChecklistItem.new
    assert item.required?
  end

  test "generates slug from title" do
    item = checklist_templates(:pre_departure_safety).checklist_items.create!(
      title: "Emergency Plan Reviewed",
      position: 10
    )
    assert_equal "emergency-plan-reviewed", item.slug
  end
end
