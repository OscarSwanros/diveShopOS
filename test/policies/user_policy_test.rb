# frozen_string_literal: true

require "test_helper"

class UserPolicyTest < ActiveSupport::TestCase
  setup do
    @owner = users(:owner_maria)
    @manager = users(:manager_carlos)
    @staff = users(:staff_ana)
  end

  test "all roles can index users" do
    [ @staff, @manager, @owner ].each do |user|
      policy = UserPolicy.new(user, @staff)
      assert policy.index?, "#{user.role} should be able to index"
    end
  end

  test "all roles can show users" do
    [ @staff, @manager, @owner ].each do |user|
      policy = UserPolicy.new(user, @staff)
      assert policy.show?, "#{user.role} should be able to show"
    end
  end

  test "only owner can create users" do
    assert UserPolicy.new(@owner, User.new).create?
    assert_not UserPolicy.new(@manager, User.new).create?
    assert_not UserPolicy.new(@staff, User.new).create?
  end

  test "owner can update any user" do
    assert UserPolicy.new(@owner, @staff).update?
    assert UserPolicy.new(@owner, @manager).update?
  end

  test "non-owner can update themselves" do
    assert UserPolicy.new(@staff, @staff).update?
    assert UserPolicy.new(@manager, @manager).update?
  end

  test "non-owner cannot update other users" do
    assert_not UserPolicy.new(@staff, @manager).update?
    assert_not UserPolicy.new(@manager, @staff).update?
  end

  test "owner can destroy other users" do
    assert UserPolicy.new(@owner, @staff).destroy?
    assert UserPolicy.new(@owner, @manager).destroy?
  end

  test "owner cannot destroy themselves" do
    assert_not UserPolicy.new(@owner, @owner).destroy?
  end

  test "non-owner cannot destroy users" do
    assert_not UserPolicy.new(@manager, @staff).destroy?
    assert_not UserPolicy.new(@staff, @manager).destroy?
  end

  test "scope returns users for user's organization" do
    scope = UserPolicy::Scope.new(@owner, User).resolve
    assert_includes scope, @owner
    assert_includes scope, @manager
    assert_includes scope, @staff
    assert_not_includes scope, users(:other_org_user)
  end
end
