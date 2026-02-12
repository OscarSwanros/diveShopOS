# frozen_string_literal: true

require "test_helper"

class ClassSessionTest < ActiveSupport::TestCase
  test "valid class session" do
    session = class_sessions(:ow_classroom_1)
    assert session.valid?
  end

  test "requires scheduled_date" do
    session = ClassSession.new(
      course_offering: course_offerings(:padi_ow_upcoming),
      start_time: "09:00"
    )
    assert_not session.valid?
    assert_includes session.errors[:scheduled_date], "can't be blank"
  end

  test "requires start_time" do
    session = ClassSession.new(
      course_offering: course_offerings(:padi_ow_upcoming),
      scheduled_date: Date.current + 7.days
    )
    assert_not session.valid?
    assert_includes session.errors[:start_time], "can't be blank"
  end

  test "session_type enum" do
    assert class_sessions(:ow_classroom_1).classroom?
    assert class_sessions(:ow_confined_1).confined_water?
    assert class_sessions(:ow_open_water_1).open_water?
  end

  test "water_session? returns true for water sessions" do
    assert class_sessions(:ow_confined_1).water_session?
    assert class_sessions(:ow_open_water_1).water_session?
  end

  test "water_session? returns false for classroom" do
    assert_not class_sessions(:ow_classroom_1).water_session?
  end

  test "by_date scope orders by date and time" do
    sessions = course_offerings(:padi_ow_upcoming).class_sessions.by_date
    dates = sessions.map(&:scheduled_date)
    assert_equal dates.sort, dates
  end

  test "water_sessions scope" do
    water = course_offerings(:padi_ow_upcoming).class_sessions.water_sessions
    assert_includes water, class_sessions(:ow_confined_1)
    assert_includes water, class_sessions(:ow_open_water_1)
    assert_not_includes water, class_sessions(:ow_classroom_1)
  end

  test "delegates organization to course_offering" do
    session = class_sessions(:ow_classroom_1)
    assert_equal organizations(:reef_divers), session.organization
  end

  test "delegates instructor to course_offering" do
    session = class_sessions(:ow_classroom_1)
    assert_equal users(:owner_maria), session.instructor
  end

  test "optional dive_site" do
    session = class_sessions(:ow_classroom_1)
    assert_nil session.dive_site

    session = class_sessions(:ow_open_water_1)
    assert_equal dive_sites(:coral_garden), session.dive_site
  end

  test "generates UUID primary key" do
    session = course_offerings(:padi_ow_upcoming).class_sessions.create!(
      scheduled_date: Date.current + 12.days,
      start_time: "14:00",
      session_type: :classroom,
      title: "Review Session"
    )
    assert_match(/\A[0-9a-f-]{36}\z/, session.id)
  end
end
