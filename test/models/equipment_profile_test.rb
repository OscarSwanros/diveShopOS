# frozen_string_literal: true

require "test_helper"

class EquipmentProfileTest < ActiveSupport::TestCase
  test "valid equipment profile" do
    profile = EquipmentProfile.new(
      customer: customers(:bob_bubbles),
      wetsuit_size: "L",
      bcd_size: "L"
    )
    assert profile.valid?
  end

  test "customer can have only one equipment profile" do
    existing = equipment_profiles(:jane_profile)
    duplicate = EquipmentProfile.new(
      customer: existing.customer,
      wetsuit_size: "S"
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:customer_id], "has already been taken"
  end
end
