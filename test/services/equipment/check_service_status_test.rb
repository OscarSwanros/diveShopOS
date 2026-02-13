# frozen_string_literal: true

require "test_helper"

class Equipment::CheckServiceStatusTest < ActiveSupport::TestCase
  test "succeeds for non-life-support equipment" do
    item = equipment_items(:fins_medium)
    result = Equipment::CheckServiceStatus.new(equipment_item: item).call

    assert result.success
    assert_nil result.reason
  end

  test "succeeds for life-support equipment with current service" do
    item = equipment_items(:bcd_medium)
    result = Equipment::CheckServiceStatus.new(equipment_item: item).call

    assert result.success
    assert_nil result.reason
  end

  test "fails for life-support equipment with no service record" do
    item = equipment_items(:regulator_no_service)
    result = Equipment::CheckServiceStatus.new(equipment_item: item).call

    assert_not result.success
    assert_includes result.reason, item.name
    assert_includes result.reason, "no service record"
  end

  test "fails for life-support equipment with overdue service" do
    item = equipment_items(:regulator_overdue)
    result = Equipment::CheckServiceStatus.new(equipment_item: item).call

    assert_not result.success
    assert_includes result.reason, item.name
    assert_includes result.reason, "overdue"
  end
end
