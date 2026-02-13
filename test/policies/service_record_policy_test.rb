# frozen_string_literal: true

require "test_helper"

class ServiceRecordPolicyTest < ActiveSupport::TestCase
  setup do
    @record = service_records(:bcd_annual)
  end

  test "all roles can read service records" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = ServiceRecordPolicy.new(user, @record)
      assert policy.index?, "#{user.role} should be able to index"
      assert policy.show?, "#{user.role} should be able to show"
    end
  end

  test "staff cannot create service records" do
    policy = ServiceRecordPolicy.new(users(:staff_ana), @record)
    assert_not policy.create?
  end

  test "manager can create service records" do
    policy = ServiceRecordPolicy.new(users(:manager_carlos), @record)
    assert policy.create?
  end

  test "manager can destroy service records" do
    policy = ServiceRecordPolicy.new(users(:manager_carlos), @record)
    assert policy.destroy?
  end
end
