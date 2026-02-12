# frozen_string_literal: true

module Courses
  class CheckMinimumAge
    Result = Data.define(:success, :reason)

    def initialize(customer:, course:, offering:)
      @customer = customer
      @course = course
      @offering = offering
    end

    def call
      return Result.new(success: true, reason: nil) unless @course.min_age

      age = @customer.age(as_of: @offering.start_date)

      if age.nil?
        Result.new(
          success: false,
          reason: I18n.t("services.courses.check_minimum_age.no_dob",
            customer: @customer.full_name)
        )
      elsif age < @course.min_age
        Result.new(
          success: false,
          reason: I18n.t("services.courses.check_minimum_age.too_young",
            customer: @customer.full_name, age: age, min_age: @course.min_age)
        )
      else
        Result.new(success: true, reason: nil)
      end
    end
  end
end
