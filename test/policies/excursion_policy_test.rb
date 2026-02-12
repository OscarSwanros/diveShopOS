# frozen_string_literal: true

require "test_helper"

class ExcursionPolicyTest < ActiveSupport::TestCase
  setup do
    @excursion = excursions(:morning_reef)
  end

  test "all roles can read excursions" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = ExcursionPolicy.new(user, @excursion)
      assert policy.index?, "#{user.role} should be able to index"
      assert policy.show?, "#{user.role} should be able to show"
    end
  end

  test "all roles can create excursions" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = ExcursionPolicy.new(user, @excursion)
      assert policy.create?, "#{user.role} should be able to create"
    end
  end

  test "all roles can update excursions" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = ExcursionPolicy.new(user, @excursion)
      assert policy.update?, "#{user.role} should be able to update"
    end
  end

  test "staff cannot destroy excursions" do
    policy = ExcursionPolicy.new(users(:staff_ana), @excursion)
    assert_not policy.destroy?
  end

  test "manager can destroy excursions" do
    policy = ExcursionPolicy.new(users(:manager_carlos), @excursion)
    assert policy.destroy?
  end

  test "owner can destroy excursions" do
    policy = ExcursionPolicy.new(users(:owner_maria), @excursion)
    assert policy.destroy?
  end

  test "scope returns excursions for user's organization" do
    scope = ExcursionPolicy::Scope.new(users(:owner_maria), Excursion).resolve
    assert_includes scope, excursions(:morning_reef)
    assert_not_includes scope, excursions(:other_org_excursion)
  end
end
