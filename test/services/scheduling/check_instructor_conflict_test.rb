# frozen_string_literal: true

require "test_helper"

class Scheduling::CheckInstructorConflictTest < ActiveSupport::TestCase
  test "succeeds when no conflicts exist" do
    result = Scheduling::CheckInstructorConflict.new(
      instructor: users(:manager_carlos),
      scheduled_date: Date.current + 30.days,
      start_time: "09:00",
      end_time: "12:00"
    ).call

    assert result.success
    assert_nil result.reason
  end

  test "fails when instructor has class session on same date and time" do
    session = class_sessions(:ow_classroom_1)
    result = Scheduling::CheckInstructorConflict.new(
      instructor: users(:owner_maria),
      scheduled_date: session.scheduled_date,
      start_time: session.start_time,
      end_time: session.end_time
    ).call

    assert_not result.success
    assert_includes result.reason, "conflict"
  end

  test "succeeds when excluding current session" do
    session = class_sessions(:ow_classroom_1)
    result = Scheduling::CheckInstructorConflict.new(
      instructor: users(:owner_maria),
      scheduled_date: session.scheduled_date,
      start_time: session.start_time,
      end_time: session.end_time,
      exclude_session_id: session.id
    ).call

    assert result.success
  end

  test "succeeds on same date but different time" do
    session = class_sessions(:ow_classroom_1)
    result = Scheduling::CheckInstructorConflict.new(
      instructor: users(:owner_maria),
      scheduled_date: session.scheduled_date,
      start_time: "14:00",
      end_time: "17:00"
    ).call

    assert result.success
  end
end
