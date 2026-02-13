# frozen_string_literal: true

require "test_helper"

class Onboarding::SeedDemoDataTest < ActiveSupport::TestCase
  setup do
    result = Onboarding::CreateShop.new(
      shop_name: "Demo Test Shop",
      owner_name: "Owner",
      email: "owner@demo.com",
      password: "password123",
      password_confirmation: "password123"
    ).call

    @org = result.organization
  end

  test "seeds dive sites" do
    Onboarding::SeedDemoData.new(organization: @org).call

    assert_equal 3, @org.dive_sites.count
    assert @org.dive_sites.exists?(name: "Coral Gardens Reef")
    assert @org.dive_sites.exists?(name: "Blue Wall")
    assert @org.dive_sites.exists?(name: "Cenote Cristal")
  end

  test "seeds staff members with instructor ratings" do
    Onboarding::SeedDemoData.new(organization: @org).call

    staff = @org.users.where.not(role: :owner)
    assert_equal 2, staff.count

    instructor = @org.users.find_by(name: "Maria Torres")
    assert_not_nil instructor
    assert instructor.instructor_ratings.exists?(agency: "PADI")

    divemaster = @org.users.find_by(name: "Jake Morrison")
    assert_not_nil divemaster
    assert divemaster.instructor_ratings.exists?(agency: "SSI")
  end

  test "seeds customers with varied profiles" do
    Onboarding::SeedDemoData.new(organization: @org).call

    assert_equal 5, @org.customers.count

    # Expired medical diver
    tom = @org.customers.find_by(first_name: "Tom")
    assert tom.medical_records.exists?(status: :expired)

    # Minor (age gate)
    alex = @org.customers.find_by(first_name: "Alex")
    assert alex.age < 15

    # Uncertified
    emily = @org.customers.find_by(first_name: "Emily")
    assert_equal 0, emily.certifications.count
  end

  test "seeds equipment with overdue service item" do
    Onboarding::SeedDemoData.new(organization: @org).call

    assert_equal 4, @org.equipment_items.count

    overdue = @org.equipment_items.find_by(name: "Reg Set Alpha")
    assert overdue.life_support?
    assert overdue.service_overdue?
  end

  test "seeds courses" do
    Onboarding::SeedDemoData.new(organization: @org).call

    assert_equal 2, @org.courses.count
    assert @org.courses.exists?(name: "Open Water Diver")
  end

  test "seeds excursions with participants" do
    Onboarding::SeedDemoData.new(organization: @org).call

    assert_equal 2, @org.excursions.count

    tomorrow_trip = @org.excursions.find_by(title: "Morning Reef Dive")
    assert_not_nil tomorrow_trip
    assert_equal 3, tomorrow_trip.trip_participants.count
    assert_equal 1, tomorrow_trip.trip_dives.count
  end
end
