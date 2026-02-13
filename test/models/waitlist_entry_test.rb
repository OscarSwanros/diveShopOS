# frozen_string_literal: true

require "test_helper"

class WaitlistEntryTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:reef_divers)
    @jane = customers(:jane_diver)
    @excursion = excursions(:full_trip)
  end

  test "creates a valid waitlist entry" do
    entry = WaitlistEntry.new(
      organization: @organization,
      customer: @jane,
      waitlistable: @excursion,
      position: 1
    )
    assert entry.valid?
    assert entry.save
  end

  test "requires position" do
    entry = WaitlistEntry.new(
      organization: @organization,
      customer: @jane,
      waitlistable: @excursion
    )
    assert_not entry.valid?
    assert_includes entry.errors[:position], "can't be blank"
  end

  test "position must be positive integer" do
    entry = WaitlistEntry.new(
      organization: @organization,
      customer: @jane,
      waitlistable: @excursion,
      position: 0
    )
    assert_not entry.valid?
  end

  test "prevents duplicate waiting entries for same customer and waitlistable" do
    WaitlistEntry.create!(
      organization: @organization,
      customer: @jane,
      waitlistable: @excursion,
      position: 1
    )

    duplicate = WaitlistEntry.new(
      organization: @organization,
      customer: @jane,
      waitlistable: @excursion,
      position: 2
    )
    assert_not duplicate.valid?
  end

  test "allows re-joining waitlist after cancellation" do
    entry = WaitlistEntry.create!(
      organization: @organization,
      customer: @jane,
      waitlistable: @excursion,
      position: 1
    )
    entry.cancel!

    new_entry = WaitlistEntry.new(
      organization: @organization,
      customer: @jane,
      waitlistable: @excursion,
      position: 2
    )
    assert new_entry.valid?
  end

  test "notify! sets status and timestamps" do
    entry = WaitlistEntry.create!(
      organization: @organization,
      customer: @jane,
      waitlistable: @excursion,
      position: 1
    )

    entry.notify!
    assert entry.notified?
    assert_not_nil entry.notified_at
    assert_not_nil entry.expires_at
  end

  test "convert! sets status to converted" do
    entry = WaitlistEntry.create!(
      organization: @organization,
      customer: @jane,
      waitlistable: @excursion,
      position: 1
    )

    entry.convert!
    assert entry.converted?
  end

  test "expire! sets status to expired" do
    entry = WaitlistEntry.create!(
      organization: @organization,
      customer: @jane,
      waitlistable: @excursion,
      position: 1
    )

    entry.expire!
    assert entry.expired?
  end

  test "active scope returns only waiting entries" do
    entry = WaitlistEntry.create!(
      organization: @organization,
      customer: @jane,
      waitlistable: @excursion,
      position: 1
    )

    bob = customers(:bob_bubbles)
    cancelled = WaitlistEntry.create!(
      organization: @organization,
      customer: bob,
      waitlistable: @excursion,
      position: 2
    )
    cancelled.cancel!

    active = @excursion.waitlist_entries.active
    assert_includes active, entry
    assert_not_includes active, cancelled
  end
end
