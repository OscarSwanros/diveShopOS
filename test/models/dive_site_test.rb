# frozen_string_literal: true

require "test_helper"

class DiveSiteTest < ActiveSupport::TestCase
  test "valid dive site" do
    site = dive_sites(:coral_garden)
    assert site.valid?
  end

  test "requires name" do
    site = DiveSite.new(organization: organizations(:reef_divers))
    assert_not site.valid?
    assert_includes site.errors[:name], "can't be blank"
  end

  test "name must be unique within organization" do
    site = DiveSite.new(
      organization: organizations(:reef_divers),
      name: "Coral Garden"
    )
    assert_not site.valid?
    assert_includes site.errors[:name], "has already been taken"
  end

  test "same name allowed in different organizations" do
    site = DiveSite.new(
      organization: organizations(:blue_water),
      name: "Coral Garden"
    )
    assert site.valid?
  end

  test "validates max_depth_meters is positive" do
    site = dive_sites(:coral_garden)
    site.max_depth_meters = -5
    assert_not site.valid?
    assert_includes site.errors[:max_depth_meters], "must be greater than 0"
  end

  test "validates latitude range" do
    site = dive_sites(:coral_garden)
    site.latitude = 91
    assert_not site.valid?

    site.latitude = -91
    assert_not site.valid?

    site.latitude = 45.0
    assert site.valid?
  end

  test "validates longitude range" do
    site = dive_sites(:coral_garden)
    site.longitude = 181
    assert_not site.valid?

    site.longitude = -181
    assert_not site.valid?

    site.longitude = -87.5
    assert site.valid?
  end

  test "difficulty level enum" do
    site = dive_sites(:coral_garden)
    assert site.beginner?

    site = dive_sites(:the_wall)
    assert site.advanced?
  end

  test "active scope" do
    active_sites = organizations(:reef_divers).dive_sites.active
    assert_includes active_sites, dive_sites(:coral_garden)
    assert_includes active_sites, dive_sites(:the_wall)
    assert_not_includes active_sites, dive_sites(:inactive_site)
  end

  test "by_difficulty scope" do
    beginner_sites = organizations(:reef_divers).dive_sites.by_difficulty(:beginner)
    assert_includes beginner_sites, dive_sites(:coral_garden)
    assert_not_includes beginner_sites, dive_sites(:the_wall)
  end

  test "belongs to organization" do
    site = dive_sites(:coral_garden)
    assert_equal organizations(:reef_divers), site.organization
  end

  test "has many trip dives" do
    site = dive_sites(:coral_garden)
    assert_includes site.trip_dives, trip_dives(:morning_dive_one)
  end

  test "generates UUID primary key" do
    site = organizations(:reef_divers).dive_sites.create!(name: "New Site")
    assert_match(/\A[0-9a-f-]{36}\z/, site.id)
  end
end
