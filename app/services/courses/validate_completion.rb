# frozen_string_literal: true

module Courses
  class ValidateCompletion
    Result = Data.define(:success, :reason)

    def initialize(enrollment:)
      @enrollment = enrollment
      @course_offering = enrollment.course_offering
    end

    def call
      sessions = @course_offering.class_sessions
      return Result.new(success: true, reason: nil) if sessions.empty?

      attended_session_ids = @enrollment.session_attendances
        .where(attended: true)
        .pluck(:class_session_id)

      missing = sessions.where.not(id: attended_session_ids)

      if missing.any?
        Result.new(
          success: false,
          reason: I18n.t("services.courses.validate_completion.missing_sessions",
            count: missing.count)
        )
      else
        Result.new(success: true, reason: nil)
      end
    end
  end
end
