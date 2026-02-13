# frozen_string_literal: true

require "test_helper"

class Onboarding::ClearDemoDataTest < ActiveSupport::TestCase
  setup do
    result = Onboarding::CreateShop.new(
      shop_name: "Clear Test Shop",
      owner_name: "Owner Clear",
      email: "owner@clear.com",
      password: "password123",
      password_confirmation: "password123"
    ).call

    @org = result.organization
    Onboarding::SeedDemoData.new(organization: @org).call
  end

  test "removes all demo data" do
    assert @org.dive_sites.any?
    assert @org.customers.any?
    assert @org.excursions.any?
    assert @org.equipment_items.any?

    Onboarding::ClearDemoData.new(organization: @org).call

    assert_equal 0, @org.dive_sites.count
    assert_equal 0, @org.customers.count
    assert_equal 0, @org.excursions.count
    assert_equal 0, @org.equipment_items.count
  end

  test "preserves owner user" do
    Onboarding::ClearDemoData.new(organization: @org).call

    assert @org.users.where(role: :owner).exists?
  end

  test "removes demo staff members" do
    assert @org.users.where.not(role: :owner).count > 0

    Onboarding::ClearDemoData.new(organization: @org).call

    assert_equal 0, @org.users.where.not(role: :owner).count
  end

  test "removes instructor ratings for demo staff" do
    staff_ids = @org.users.where.not(role: :owner).pluck(:id)
    assert InstructorRating.where(user_id: staff_ids).any?

    Onboarding::ClearDemoData.new(organization: @org).call

    assert_equal 0, InstructorRating.where(user_id: staff_ids).count
  end
end
