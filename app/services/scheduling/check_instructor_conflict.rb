# frozen_string_literal: true

module Scheduling
  class CheckInstructorConflict
    Result = Data.define(:success, :reason)

    def initialize(instructor:, scheduled_date:, start_time:, end_time:, exclude_session_id: nil)
      @instructor = instructor
      @scheduled_date = scheduled_date
      @start_time = start_time
      @end_time = end_time
      @exclude_session_id = exclude_session_id
    end

    def call
      conflicting = find_conflicting_sessions
      conflicting = find_conflicting_excursions if conflicting.empty?

      if conflicting.any?
        Result.new(
          success: false,
          reason: I18n.t("services.scheduling.check_instructor_conflict.conflict",
            instructor: @instructor.name, date: I18n.l(@scheduled_date, format: :long))
        )
      else
        Result.new(success: true, reason: nil)
      end
    end

    private

    def find_conflicting_sessions
      sessions = ClassSession
        .joins(:course_offering)
        .where(course_offerings: { instructor_id: @instructor.id })
        .where(scheduled_date: @scheduled_date)

      sessions = sessions.where.not(id: @exclude_session_id) if @exclude_session_id
      sessions = filter_by_time_overlap(sessions)
      sessions
    end

    def find_conflicting_excursions
      Excursion
        .where(scheduled_date: @scheduled_date)
        .joins("INNER JOIN trip_participants ON trip_participants.excursion_id = excursions.id")
        .where(trip_participants: { role: [ :instructor, :divemaster ] })
        .none
    end

    def filter_by_time_overlap(sessions)
      return sessions unless @end_time

      sessions.where("start_time < ? AND (end_time IS NULL OR end_time > ?)", @end_time, @start_time)
    end
  end
end
