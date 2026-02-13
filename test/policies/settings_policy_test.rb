# frozen_string_literal: true

require "test_helper"

class SettingsPolicyTest < ActiveSupport::TestCase
  setup do
    @owner = users(:owner_maria)
    @manager = users(:manager_carlos)
    @staff = users(:staff_ana)
  end

  test "owner can access domain settings" do
    policy = SettingsPolicy.new(@owner, :settings)
    assert policy.domain?
  end

  test "manager cannot access domain settings" do
    policy = SettingsPolicy.new(@manager, :settings)
    assert_not policy.domain?
  end

  test "staff cannot access domain settings" do
    policy = SettingsPolicy.new(@staff, :settings)
    assert_not policy.domain?
  end
end
