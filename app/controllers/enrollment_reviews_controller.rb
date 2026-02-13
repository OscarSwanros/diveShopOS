# frozen_string_literal: true

class EnrollmentReviewsController < ApplicationController
  before_action :set_enrollment

  def approve
    authorize @enrollment, :review?

    @enrollment.update!(
      status: :confirmed,
      enrolled_at: Time.current
    )

    CustomerAccountMailer.enrollment_approved(@enrollment).deliver_later
    redirect_to review_queue_path, notice: I18n.t("review_queue.approved")
  end

  def decline
    authorize @enrollment, :review?

    @enrollment.decline!(reason: params[:reason])

    CustomerAccountMailer.enrollment_declined(@enrollment).deliver_later
    redirect_to review_queue_path, notice: I18n.t("review_queue.declined")
  end

  private

  def set_enrollment
    @enrollment = Enrollment
      .joins(:course_offering)
      .where(course_offerings: { organization_id: current_organization.id })
      .find_by!(slug: params[:id])
  end
end
