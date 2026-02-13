# frozen_string_literal: true

module Public
  class EnrollmentRequestsController < Public::BaseController
    before_action :require_customer_authentication
    before_action :set_course_and_offering

    def new
    end

    def create
      result = Public::RequestEnrollment.new(
        customer: current_customer_account.customer,
        course_offering: @offering
      ).call

      if result.success
        CustomerAccountMailer.enrollment_request_submitted(result.enrollment).deliver_later
        StaffNotificationMailer.new_enrollment_request(result.enrollment).deliver_later
        redirect_to catalog_course_path(@course),
          notice: I18n.t("public.enrollment_requests.created")
      else
        flash.now[:alert] = result.error
        render :new, status: :unprocessable_entity
      end
    end

    private

    def set_course_and_offering
      @course = current_organization.courses.active.find_by!(slug: params[:course_slug])
      @offering = @course.course_offerings.published.find_by!(slug: params[:offering_slug])
    end
  end
end
