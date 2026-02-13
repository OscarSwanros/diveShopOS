# frozen_string_literal: true

require "test_helper"

class EquipmentItemTest < ActiveSupport::TestCase
  test "valid equipment item" do
    item = EquipmentItem.new(
      organization: organizations(:reef_divers),
      category: :fins,
      name: "Test Fins",
      status: :available,
      life_support: false
    )
    assert item.valid?
  end

  test "requires name" do
    item = equipment_items(:fins_medium)
    item.name = nil
    assert_not item.valid?
    assert_includes item.errors[:name], "can't be blank"
  end

  test "requires serial number for life support equipment" do
    item = EquipmentItem.new(
      organization: organizations(:reef_divers),
      category: :regulator,
      name: "Test Reg",
      life_support: true,
      serial_number: nil
    )
    assert_not item.valid?
    assert_includes item.errors[:serial_number], "can't be blank"
  end

  test "does not require serial number for non-life-support equipment" do
    item = EquipmentItem.new(
      organization: organizations(:reef_divers),
      category: :fins,
      name: "Test Fins",
      life_support: false,
      serial_number: nil
    )
    assert item.valid?
  end

  test "serial number unique within organization" do
    existing = equipment_items(:bcd_medium)
    item = EquipmentItem.new(
      organization: existing.organization,
      category: :bcd,
      name: "Duplicate Serial",
      serial_number: existing.serial_number,
      life_support: true
    )
    assert_not item.valid?
    assert_includes item.errors[:serial_number], "has already been taken"
  end

  test "service_current? returns true for non-life-support gear" do
    item = equipment_items(:fins_medium)
    assert item.service_current?
  end

  test "service_current? returns true when life support gear has future service date" do
    item = equipment_items(:bcd_medium)
    assert item.service_current?
  end

  test "service_current? returns false when life support gear is overdue" do
    item = equipment_items(:regulator_overdue)
    assert_not item.service_current?
  end

  test "service_current? returns false when life support gear has no service record" do
    item = equipment_items(:regulator_no_service)
    assert_not item.service_current?
  end

  test "service_overdue? returns false for non-life-support gear" do
    item = equipment_items(:fins_medium)
    assert_not item.service_overdue?
  end

  test "service_overdue? returns true when life support gear is overdue" do
    item = equipment_items(:regulator_overdue)
    assert item.service_overdue?
  end

  test "active scope excludes retired items" do
    org = organizations(:reef_divers)
    active_items = org.equipment_items.active
    assert_not_includes active_items, equipment_items(:retired_bcd)
  end

  test "by_category scope filters correctly" do
    org = organizations(:reef_divers)
    regs = org.equipment_items.by_category(:regulator)
    regs.each { |item| assert_equal "regulator", item.category }
  end

  test "by_size scope filters correctly" do
    org = organizations(:reef_divers)
    medium = org.equipment_items.by_size("M")
    medium.each { |item| assert_equal "M", item.size }
  end
end
