# frozen_string_literal: true

require "test_helper"

class EquipmentProfilePolicyTest < ActiveSupport::TestCase
  setup do
    @profile = equipment_profiles(:jane_profile)
  end

  test "all roles can read equipment profiles" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = EquipmentProfilePolicy.new(user, @profile)
      assert policy.show?, "#{user.role} should be able to show"
    end
  end

  test "all roles can create equipment profiles" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = EquipmentProfilePolicy.new(user, @profile)
      assert policy.create?, "#{user.role} should be able to create"
    end
  end

  test "all roles can update equipment profiles" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = EquipmentProfilePolicy.new(user, @profile)
      assert policy.update?, "#{user.role} should be able to update"
    end
  end

  test "staff cannot destroy equipment profiles" do
    policy = EquipmentProfilePolicy.new(users(:staff_ana), @profile)
    assert_not policy.destroy?
  end

  test "manager can destroy equipment profiles" do
    policy = EquipmentProfilePolicy.new(users(:manager_carlos), @profile)
    assert policy.destroy?
  end
end
