# frozen_string_literal: true

module Courses
  class CheckMedicalClearance
    Result = Data.define(:success, :reason)

    def initialize(customer:, course_offering:)
      @customer = customer
      @course_offering = course_offering
    end

    def call
      return Result.new(success: true, reason: nil) unless has_water_sessions?

      clearance = @customer.current_medical_clearance

      if clearance&.valid_clearance?
        Result.new(success: true, reason: nil)
      else
        Result.new(
          success: false,
          reason: I18n.t("services.courses.check_medical_clearance.no_clearance",
            customer: @customer.full_name)
        )
      end
    end

    private

    def has_water_sessions?
      @course_offering.class_sessions.water_sessions.exists?
    end
  end
end
