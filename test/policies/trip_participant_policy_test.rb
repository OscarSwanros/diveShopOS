# frozen_string_literal: true

require "test_helper"

class TripParticipantPolicyTest < ActiveSupport::TestCase
  setup do
    @participant = trip_participants(:diver_jane)
  end

  test "all roles can create trip participants" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = TripParticipantPolicy.new(user, @participant)
      assert policy.create?, "#{user.role} should be able to create"
    end
  end

  test "all roles can update trip participants" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = TripParticipantPolicy.new(user, @participant)
      assert policy.update?, "#{user.role} should be able to update"
    end
  end

  test "all roles can destroy trip participants" do
    [ users(:staff_ana), users(:manager_carlos), users(:owner_maria) ].each do |user|
      policy = TripParticipantPolicy.new(user, @participant)
      assert policy.destroy?, "#{user.role} should be able to destroy"
    end
  end

  test "scope returns trip participants for user's organization" do
    scope = TripParticipantPolicy::Scope.new(users(:owner_maria), TripParticipant).resolve
    assert_includes scope, trip_participants(:diver_jane)
  end
end
