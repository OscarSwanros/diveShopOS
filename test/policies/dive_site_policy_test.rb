# frozen_string_literal: true

require "test_helper"

class DiveSitePolicyTest < ActiveSupport::TestCase
  setup do
    @site = dive_sites(:coral_garden)
  end

  test "staff can read dive sites" do
    policy = DiveSitePolicy.new(users(:staff_ana), @site)
    assert policy.index?
    assert policy.show?
  end

  test "staff cannot create dive sites" do
    policy = DiveSitePolicy.new(users(:staff_ana), @site)
    assert_not policy.create?
  end

  test "staff cannot update dive sites" do
    policy = DiveSitePolicy.new(users(:staff_ana), @site)
    assert_not policy.update?
  end

  test "staff cannot destroy dive sites" do
    policy = DiveSitePolicy.new(users(:staff_ana), @site)
    assert_not policy.destroy?
  end

  test "manager can create dive sites" do
    policy = DiveSitePolicy.new(users(:manager_carlos), @site)
    assert policy.create?
  end

  test "manager can update dive sites" do
    policy = DiveSitePolicy.new(users(:manager_carlos), @site)
    assert policy.update?
  end

  test "manager can destroy dive sites" do
    policy = DiveSitePolicy.new(users(:manager_carlos), @site)
    assert policy.destroy?
  end

  test "owner can manage dive sites" do
    policy = DiveSitePolicy.new(users(:owner_maria), @site)
    assert policy.create?
    assert policy.update?
    assert policy.destroy?
  end

  test "scope returns sites for user's organization" do
    scope = DiveSitePolicy::Scope.new(users(:owner_maria), DiveSite).resolve
    assert_includes scope, dive_sites(:coral_garden)
    assert_not_includes scope, dive_sites(:other_org_site)
  end
end
