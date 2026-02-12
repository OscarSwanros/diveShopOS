# frozen_string_literal: true

module Courses
  class CheckStudentRatio
    Result = Data.define(:success, :reason)

    def initialize(course_offering:)
      @course_offering = course_offering
    end

    def call
      current_count = @course_offering.enrollments.countable.count
      max = @course_offering.max_students

      if current_count >= max
        Result.new(
          success: false,
          reason: I18n.t("services.courses.check_student_ratio.at_capacity",
            count: current_count, max: max)
        )
      else
        Result.new(success: true, reason: nil)
      end
    end
  end
end
