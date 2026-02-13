# frozen_string_literal: true

require "test_helper"

class Equipment::CheckTankComplianceTest < ActiveSupport::TestCase
  test "succeeds when both VIP and hydro are current" do
    tank = customer_tanks(:jane_al80)
    result = Equipment::CheckTankCompliance.new(customer_tank: tank).call

    assert result.success
    assert_nil result.reason
  end

  test "fails when VIP is expired" do
    tank = customer_tanks(:jane_hp100)
    result = Equipment::CheckTankCompliance.new(customer_tank: tank).call

    assert_not result.success
    assert_includes result.reason, tank.serial_number
    assert_includes result.reason, "visual inspection"
  end

  test "fails when hydro is missing" do
    tank = customer_tanks(:bob_tank_no_hydro)
    result = Equipment::CheckTankCompliance.new(customer_tank: tank).call

    assert_not result.success
    assert_includes result.reason, tank.serial_number
    assert_includes result.reason, "hydrostatic test"
  end

  test "fails when VIP date is nil" do
    tank = customer_tanks(:jane_al80)
    tank.vip_due_date = nil
    result = Equipment::CheckTankCompliance.new(customer_tank: tank).call

    assert_not result.success
    assert_includes result.reason, "visual inspection"
  end

  test "fails when hydro date is nil" do
    tank = customer_tanks(:jane_al80)
    tank.hydro_due_date = nil
    result = Equipment::CheckTankCompliance.new(customer_tank: tank).call

    assert_not result.success
    assert_includes result.reason, "hydrostatic test"
  end
end
