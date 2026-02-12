# frozen_string_literal: true

require "test_helper"

class TripDivePolicyTest < ActiveSupport::TestCase
  setup do
    @trip_dive = trip_dives(:morning_dive_one)
  end

  test "all roles can create trip dives" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = TripDivePolicy.new(user, @trip_dive)
      assert policy.create?, "#{user.role} should be able to create"
    end
  end

  test "all roles can update trip dives" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = TripDivePolicy.new(user, @trip_dive)
      assert policy.update?, "#{user.role} should be able to update"
    end
  end

  test "all roles can destroy trip dives" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = TripDivePolicy.new(user, @trip_dive)
      assert policy.destroy?, "#{user.role} should be able to destroy"
    end
  end

  test "scope returns trip dives for user's organization" do
    scope = TripDivePolicy::Scope.new(users(:owner_maria), TripDive).resolve
    assert_includes scope, trip_dives(:morning_dive_one)
  end
end
