# frozen_string_literal: true

require "test_helper"

class CourseOfferingTest < ActiveSupport::TestCase
  test "valid course offering" do
    offering = course_offerings(:padi_ow_upcoming)
    assert offering.valid?
  end

  test "requires start_date" do
    offering = CourseOffering.new(
      course: courses(:padi_ow),
      organization: organizations(:reef_divers),
      instructor: users(:owner_maria),
      max_students: 8
    )
    assert_not offering.valid?
    assert_includes offering.errors[:start_date], "can't be blank"
  end

  test "requires max_students" do
    offering = CourseOffering.new(
      course: courses(:padi_ow),
      organization: organizations(:reef_divers),
      instructor: users(:owner_maria),
      start_date: Date.current + 30.days
    )
    assert_not offering.valid?
    assert_includes offering.errors[:max_students], "can't be blank"
  end

  test "max_students must be positive" do
    offering = course_offerings(:padi_ow_upcoming)
    offering.max_students = 0
    assert_not offering.valid?
  end

  test "status enum" do
    assert course_offerings(:padi_ow_upcoming).published?
    assert course_offerings(:padi_aow_draft).draft?
  end

  test "upcoming scope" do
    upcoming = organizations(:reef_divers).course_offerings.upcoming
    assert_includes upcoming, course_offerings(:padi_ow_upcoming)
  end

  test "effective_price_cents uses offering price when set" do
    offering = course_offerings(:padi_aow_draft)
    assert_equal 28000, offering.effective_price_cents
  end

  test "effective_price_cents falls back to course price" do
    offering = course_offerings(:padi_ow_upcoming)
    assert_equal courses(:padi_ow).price_cents, offering.effective_price_cents
  end

  test "effective_price_currency falls back to course currency" do
    offering = course_offerings(:padi_ow_upcoming)
    assert_equal courses(:padi_ow).price_currency, offering.effective_price_currency
  end

  test "has many class sessions" do
    offering = course_offerings(:padi_ow_upcoming)
    assert_equal 4, offering.class_sessions.count
  end

  test "destroys class sessions when destroyed" do
    offering = course_offerings(:padi_ow_upcoming)
    session_count = offering.class_sessions.count
    assert_difference("ClassSession.count", -session_count) do
      offering.destroy
    end
  end

  test "generates UUID primary key" do
    offering = CourseOffering.create!(
      course: courses(:padi_ow),
      organization: organizations(:reef_divers),
      instructor: users(:owner_maria),
      start_date: Date.current + 60.days,
      max_students: 8
    )
    assert_match(/\A[0-9a-f-]{36}\z/, offering.id)
  end
end
