# frozen_string_literal: true

require "test_helper"

class OnboardingChecklistTest < ActiveSupport::TestCase
  setup do
    @org = organizations(:reef_divers)
    @checklist = OnboardingChecklist.new(organization: @org)
  end

  test "has 7 steps" do
    assert_equal 7, @checklist.total_count
  end

  test "dive site step is complete when organization has dive sites" do
    step = @checklist.steps.find { |s| s.key == :add_dive_site }
    assert step.completed, "Should be completed because reef_divers has dive sites"
  end

  test "staff step is complete when non-owner users exist" do
    step = @checklist.steps.find { |s| s.key == :add_staff }
    assert step.completed, "Should be completed because reef_divers has non-owner staff"
  end

  test "excursion step is complete when excursions exist" do
    step = @checklist.steps.find { |s| s.key == :schedule_excursion }
    assert step.completed
  end

  test "customer step is complete when customers exist" do
    step = @checklist.steps.find { |s| s.key == :add_customer }
    assert step.completed
  end

  test "progress percentage reflects completed steps" do
    assert @checklist.progress_percentage > 0
    assert @checklist.progress_percentage <= 100
  end

  test "new org with no data has all steps incomplete" do
    result = Onboarding::CreateShop.new(
      shop_name: "Blank Shop",
      owner_name: "Blank Owner",
      email: "blank@shop.com",
      password: "password123",
      password_confirmation: "password123"
    ).call

    checklist = OnboardingChecklist.new(organization: result.organization)

    assert_equal 0, checklist.completed_count
    assert_equal 0, checklist.progress_percentage
    assert_not checklist.complete?
  end

  test "complete? returns false when steps remain" do
    result = Onboarding::CreateShop.new(
      shop_name: "Partial Shop",
      owner_name: "Partial Owner",
      email: "partial@shop.com",
      password: "password123",
      password_confirmation: "password123"
    ).call

    checklist = OnboardingChecklist.new(organization: result.organization)
    assert_not checklist.complete?
  end
end
