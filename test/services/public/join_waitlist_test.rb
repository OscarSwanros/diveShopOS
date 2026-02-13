# frozen_string_literal: true

require "test_helper"

class Public::JoinWaitlistTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:reef_divers)
    @jane = customers(:jane_diver)
    @full_excursion = excursions(:full_trip)
  end

  test "creates a waitlist entry with correct position" do
    result = Public::JoinWaitlist.new(
      customer: @jane,
      waitlistable: @full_excursion
    ).call

    assert result.success
    assert_not_nil result.waitlist_entry
    assert_equal 1, result.waitlist_entry.position
    assert result.waitlist_entry.waiting?
  end

  test "increments position for subsequent entries" do
    Public::JoinWaitlist.new(customer: @jane, waitlistable: @full_excursion).call

    bob = customers(:bob_bubbles)
    result = Public::JoinWaitlist.new(customer: bob, waitlistable: @full_excursion).call

    assert result.success
    assert_equal 2, result.waitlist_entry.position
  end

  test "rejects duplicate waiting entries" do
    Public::JoinWaitlist.new(customer: @jane, waitlistable: @full_excursion).call

    result = Public::JoinWaitlist.new(customer: @jane, waitlistable: @full_excursion).call

    assert_not result.success
    assert_equal I18n.t("public.waitlist.already_on_list"), result.error
  end

  test "allows re-joining after cancellation" do
    first = Public::JoinWaitlist.new(customer: @jane, waitlistable: @full_excursion).call
    first.waitlist_entry.cancel!

    result = Public::JoinWaitlist.new(customer: @jane, waitlistable: @full_excursion).call
    assert result.success
  end

  test "works with course offerings" do
    offering = course_offerings(:padi_ow_full)

    result = Public::JoinWaitlist.new(
      customer: @jane,
      waitlistable: offering
    ).call

    assert result.success
    assert_equal "CourseOffering", result.waitlist_entry.waitlistable_type
  end
end
