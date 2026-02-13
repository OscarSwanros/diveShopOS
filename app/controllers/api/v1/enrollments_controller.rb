# frozen_string_literal: true

module Api
  module V1
    class EnrollmentsController < BaseController
      include ApiPagination

      before_action :set_course_and_offering
      before_action :set_enrollment, only: [ :show, :update, :destroy, :complete ]

      def index
        @enrollments = paginate(@course_offering.enrollments.includes(:customer).order("customers.last_name"))
      end

      def show
      end

      def create
        @enrollment = @course_offering.enrollments.build(enrollment_params)
        authorize @enrollment

        gates = [
          Courses::CheckStudentRatio.new(course_offering: @course_offering),
          Courses::CheckMinimumAge.new(
            customer: @enrollment.customer,
            course: @course_offering.course,
            offering: @course_offering
          ),
          Courses::CheckMedicalClearance.new(
            customer: @enrollment.customer,
            course_offering: @course_offering
          )
        ]

        failed_gate = gates.map(&:call).find { |result| !result.success }
        if failed_gate
          return render_safety_gate_failure(failed_gate)
        end

        @enrollment.enrolled_at = Time.current

        if @enrollment.save
          EnrollmentMailer.confirmation(@enrollment).deliver_later
          render :show, status: :created
        else
          render_validation_errors(@enrollment)
        end
      end

      def update
        if @enrollment.update(enrollment_params)
          render :show
        else
          render_validation_errors(@enrollment)
        end
      end

      def complete
        result = Courses::CompleteEnrollment.new(
          enrollment: @enrollment,
          organization: current_organization
        ).call

        if result.success
          @enrollment.reload
          render :show
        else
          render json: {
            error: { code: "completion_failed", message: result.reason }
          }, status: :unprocessable_entity
        end
      end

      def destroy
        @enrollment.withdraw!
        head :no_content
      end

      private

      def set_course_and_offering
        @course = find_by_slug_or_id(current_organization.courses, params[:course_id])
        @course_offering = find_by_slug_or_id(@course.course_offerings, params[:course_offering_id])
      end

      def set_enrollment
        @enrollment = find_by_slug_or_id(@course_offering.enrollments, params[:id])
        authorize @enrollment
      end

      def enrollment_params
        params.require(:enrollment).permit(:customer_id, :status, :paid, :notes)
      end
    end
  end
end
