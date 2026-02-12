# frozen_string_literal: true

module Courses
  class CheckInstructorRating
    Result = Data.define(:success, :reason)

    def initialize(instructor:, course:)
      @instructor = instructor
      @course = course
    end

    def call
      matching_rating = @instructor.instructor_ratings.current.for_agency(@course.agency).first

      if matching_rating
        Result.new(success: true, reason: nil)
      else
        Result.new(
          success: false,
          reason: I18n.t("services.courses.check_instructor_rating.no_rating",
            instructor: @instructor.name, agency: @course.agency)
        )
      end
    end
  end
end
