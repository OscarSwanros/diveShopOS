# frozen_string_literal: true

require "test_helper"

class CustomerTankTest < ActiveSupport::TestCase
  test "valid customer tank" do
    tank = CustomerTank.new(
      customer: customers(:bob_bubbles),
      organization: organizations(:reef_divers),
      serial_number: "NEW-TANK-001"
    )
    assert tank.valid?
  end

  test "requires serial number" do
    tank = customer_tanks(:jane_al80)
    tank.serial_number = nil
    assert_not tank.valid?
  end

  test "serial number unique within organization" do
    existing = customer_tanks(:jane_al80)
    tank = CustomerTank.new(
      customer: customers(:bob_bubbles),
      organization: existing.organization,
      serial_number: existing.serial_number
    )
    assert_not tank.valid?
    assert_includes tank.errors[:serial_number], "has already been taken"
  end

  test "vip_current? returns true when vip_due_date is in the future" do
    tank = customer_tanks(:jane_al80)
    assert tank.vip_current?
  end

  test "vip_current? returns false when vip_due_date is in the past" do
    tank = customer_tanks(:jane_hp100)
    assert_not tank.vip_current?
  end

  test "vip_current? returns false when vip_due_date is nil" do
    tank = customer_tanks(:bob_tank_no_hydro)
    tank.vip_due_date = nil
    assert_not tank.vip_current?
  end

  test "hydro_current? returns true when hydro_due_date is in the future" do
    tank = customer_tanks(:jane_al80)
    assert tank.hydro_current?
  end

  test "hydro_current? returns false when hydro_due_date is nil" do
    tank = customer_tanks(:bob_tank_no_hydro)
    assert_not tank.hydro_current?
  end

  test "fill_compliant? returns true when both vip and hydro are current" do
    tank = customer_tanks(:jane_al80)
    assert tank.fill_compliant?
  end

  test "fill_compliant? returns false when vip is expired" do
    tank = customer_tanks(:jane_hp100)
    assert_not tank.fill_compliant?
  end

  test "fill_compliant? returns false when hydro is missing" do
    tank = customer_tanks(:bob_tank_no_hydro)
    assert_not tank.fill_compliant?
  end

  test "compliant scope returns only fully compliant tanks" do
    compliant = CustomerTank.compliant
    compliant.each do |tank|
      assert tank.fill_compliant?, "Tank #{tank.serial_number} should be compliant"
    end
  end
end
