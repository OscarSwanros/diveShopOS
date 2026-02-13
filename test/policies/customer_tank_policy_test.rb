# frozen_string_literal: true

require "test_helper"

class CustomerTankPolicyTest < ActiveSupport::TestCase
  setup do
    @tank = customer_tanks(:jane_al80)
  end

  test "all roles can read customer tanks" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = CustomerTankPolicy.new(user, @tank)
      assert policy.index?, "#{user.role} should be able to index"
      assert policy.show?, "#{user.role} should be able to show"
    end
  end

  test "all roles can create customer tanks" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = CustomerTankPolicy.new(user, @tank)
      assert policy.create?, "#{user.role} should be able to create"
    end
  end

  test "all roles can update customer tanks" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = CustomerTankPolicy.new(user, @tank)
      assert policy.update?, "#{user.role} should be able to update"
    end
  end

  test "staff cannot destroy customer tanks" do
    policy = CustomerTankPolicy.new(users(:staff_ana), @tank)
    assert_not policy.destroy?
  end

  test "manager can destroy customer tanks" do
    policy = CustomerTankPolicy.new(users(:manager_carlos), @tank)
    assert policy.destroy?
  end

  test "scope returns tanks for user's organization" do
    scope = CustomerTankPolicy::Scope.new(users(:owner_maria), CustomerTank).resolve
    assert_includes scope, customer_tanks(:jane_al80)
    assert_not_includes scope, customer_tanks(:other_org_tank)
  end
end
