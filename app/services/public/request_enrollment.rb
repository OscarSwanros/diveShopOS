# frozen_string_literal: true

module Public
  class RequestEnrollment
    Result = Data.define(:success, :enrollment, :error)

    def initialize(customer:, course_offering:)
      @customer = customer
      @course_offering = course_offering
    end

    def call
      # Check for duplicate
      existing = @course_offering.enrollments
        .where(customer: @customer)
        .where.not(status: [ :withdrawn, :failed, :declined ])
        .exists?

      if existing
        return Result.new(
          success: false,
          enrollment: nil,
          error: I18n.t("public.enrollment_requests.duplicate")
        )
      end

      # Run safety gates and collect results
      gate_results = run_safety_gates

      enrollment = @course_offering.enrollments.build(
        customer: @customer,
        status: :requested,
        requested_at: Time.current,
        safety_gate_results: gate_results
      )

      if enrollment.save
        Result.new(success: true, enrollment: enrollment, error: nil)
      else
        Result.new(success: false, enrollment: enrollment, error: enrollment.errors.full_messages.join(", "))
      end
    end

    private

    def run_safety_gates
      results = {}

      # Student ratio check
      ratio_result = Courses::CheckStudentRatio.new(course_offering: @course_offering).call
      results["student_ratio"] = { passed: ratio_result.success, reason: ratio_result.reason }

      # Minimum age check
      if @course_offering.course.min_age.to_i > 0
        age_result = Courses::CheckMinimumAge.new(customer: @customer, course: @course_offering.course, offering: @course_offering).call
        results["minimum_age"] = { passed: age_result.success, reason: age_result.reason }
      end

      # Medical clearance check
      medical_result = Courses::CheckMedicalClearance.new(customer: @customer, course_offering: @course_offering).call
      results["medical_clearance"] = { passed: medical_result.success, reason: medical_result.reason }

      results
    end
  end
end
