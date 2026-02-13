# frozen_string_literal: true

require "test_helper"

class ChecklistTemplateTest < ActiveSupport::TestCase
  test "valid template" do
    template = checklist_templates(:pre_departure_safety)
    assert template.valid?
  end

  test "requires title" do
    template = ChecklistTemplate.new(
      organization: organizations(:reef_divers),
      category: :safety
    )
    assert_not template.valid?
    assert_includes template.errors[:title], "can't be blank"
  end

  test "requires category" do
    template = ChecklistTemplate.new(
      organization: organizations(:reef_divers),
      title: "Test"
    )
    assert_not template.valid?
    assert_includes template.errors[:category], "can't be blank"
  end

  test "title is unique within organization" do
    template = ChecklistTemplate.new(
      organization: organizations(:reef_divers),
      title: "Pre-Departure Safety Check",
      category: :safety
    )
    assert_not template.valid?
    assert_includes template.errors[:title], "has already been taken"
  end

  test "same title allowed in different organizations" do
    template = ChecklistTemplate.new(
      organization: organizations(:blue_water),
      title: "Pre-Departure Safety Check",
      category: :safety
    )
    assert template.valid?
  end

  test "category enum" do
    assert checklist_templates(:pre_departure_safety).safety?
    assert checklist_templates(:shop_open).operational?
    assert checklist_templates(:annual_inspection).compliance?
  end

  test "active scope" do
    active = organizations(:reef_divers).checklist_templates.active
    assert_includes active, checklist_templates(:pre_departure_safety)
    assert_not_includes active, checklist_templates(:inactive_template)
  end

  test "by_category scope" do
    safety = organizations(:reef_divers).checklist_templates.by_category(:safety)
    assert_includes safety, checklist_templates(:pre_departure_safety)
    assert_not_includes safety, checklist_templates(:shop_open)
  end

  test "has many checklist items" do
    template = checklist_templates(:pre_departure_safety)
    assert_equal 5, template.checklist_items.count
  end

  test "items_ordered returns items by position" do
    template = checklist_templates(:pre_departure_safety)
    items = template.items_ordered
    assert_equal 0, items.first.position
    assert_equal 4, items.last.position
  end

  test "destroys items when destroyed" do
    template = checklist_templates(:annual_inspection)
    assert_difference("ChecklistTemplate.count", -1) do
      template.destroy
    end
  end

  test "cannot destroy template with runs" do
    template = checklist_templates(:pre_departure_safety)
    assert_no_difference("ChecklistTemplate.count") do
      template.destroy
    end
    assert template.errors[:base].any?
  end

  test "generates slug from title" do
    template = organizations(:reef_divers).checklist_templates.create!(
      title: "New Template",
      category: :operational
    )
    assert_equal "new-template", template.slug
  end

  test "generates UUID primary key" do
    template = organizations(:reef_divers).checklist_templates.create!(
      title: "UUID Test",
      category: :operational
    )
    assert_match(/\A[0-9a-f-]{36}\z/, template.id)
  end
end
