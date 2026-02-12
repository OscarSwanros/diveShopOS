# frozen_string_literal: true

module Courses
  class CompleteEnrollment
    Result = Data.define(:success, :reason, :certification)

    def initialize(enrollment:, organization:)
      @enrollment = enrollment
      @organization = organization
      @course_offering = enrollment.course_offering
      @course = @course_offering.course
    end

    def call
      validation = ValidateCompletion.new(enrollment: @enrollment).call
      unless validation.success
        return Result.new(success: false, reason: validation.reason, certification: nil)
      end

      ActiveRecord::Base.transaction do
        certification = nil

        if @course.certification?
          certification = @enrollment.customer.certifications.create!(
            agency: @course.agency,
            certification_level: @course.level,
            issued_date: Date.current,
            issuing_organization: @organization
          )
        end

        @enrollment.complete!(certification: certification)

        EnrollmentMailer.completion(@enrollment.reload).deliver_later

        Result.new(success: true, reason: nil, certification: certification)
      end
    rescue ActiveRecord::RecordInvalid => e
      Result.new(success: false, reason: e.message, certification: nil)
    end
  end
end
