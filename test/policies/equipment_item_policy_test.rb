# frozen_string_literal: true

require "test_helper"

class EquipmentItemPolicyTest < ActiveSupport::TestCase
  setup do
    @item = equipment_items(:bcd_medium)
  end

  test "all roles can read equipment items" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = EquipmentItemPolicy.new(user, @item)
      assert policy.index?, "#{user.role} should be able to index"
      assert policy.show?, "#{user.role} should be able to show"
    end
  end

  test "staff cannot create equipment items" do
    policy = EquipmentItemPolicy.new(users(:staff_ana), @item)
    assert_not policy.create?
  end

  test "manager can create equipment items" do
    policy = EquipmentItemPolicy.new(users(:manager_carlos), @item)
    assert policy.create?
  end

  test "owner can create equipment items" do
    policy = EquipmentItemPolicy.new(users(:owner_maria), @item)
    assert policy.create?
  end

  test "staff cannot update equipment items" do
    policy = EquipmentItemPolicy.new(users(:staff_ana), @item)
    assert_not policy.update?
  end

  test "manager can update equipment items" do
    policy = EquipmentItemPolicy.new(users(:manager_carlos), @item)
    assert policy.update?
  end

  test "staff cannot destroy equipment items" do
    policy = EquipmentItemPolicy.new(users(:staff_ana), @item)
    assert_not policy.destroy?
  end

  test "manager cannot destroy equipment items" do
    policy = EquipmentItemPolicy.new(users(:manager_carlos), @item)
    assert_not policy.destroy?
  end

  test "owner can destroy equipment items" do
    policy = EquipmentItemPolicy.new(users(:owner_maria), @item)
    assert policy.destroy?
  end

  test "scope returns items for user's organization" do
    scope = EquipmentItemPolicy::Scope.new(users(:owner_maria), EquipmentItem).resolve
    assert_includes scope, equipment_items(:bcd_medium)
    assert_not_includes scope, equipment_items(:other_org_equipment)
  end
end
