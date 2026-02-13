# frozen_string_literal: true

class EnrollmentsController < ApplicationController
  before_action :set_course_and_offering
  before_action :set_enrollment, only: [ :edit, :update, :destroy, :complete ]

  def new
    @enrollment = @course_offering.enrollments.build
    authorize @enrollment
    @customers = current_organization.customers.active.by_name
  end

  def create
    @enrollment = @course_offering.enrollments.build(enrollment_params)
    authorize @enrollment

    # Run safety gates
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
      @enrollment.errors.add(:base, failed_gate.reason)
      @customers = current_organization.customers.active.by_name
      render :new, status: :unprocessable_entity
      return
    end

    @enrollment.enrolled_at = Time.current

    if @enrollment.save
      EnrollmentMailer.confirmation(@enrollment).deliver_later
      redirect_to course_course_offering_path(@course, @course_offering),
        notice: I18n.t("enrollments.created")
    else
      @customers = current_organization.customers.active.by_name
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @customers = current_organization.customers.active.by_name
  end

  def update
    if @enrollment.update(enrollment_params)
      redirect_to course_course_offering_path(@course, @course_offering),
        notice: I18n.t("enrollments.updated")
    else
      @customers = current_organization.customers.active.by_name
      render :edit, status: :unprocessable_entity
    end
  end

  def complete
    result = Courses::CompleteEnrollment.new(
      enrollment: @enrollment,
      organization: current_organization
    ).call

    if result.success
      redirect_to course_course_offering_path(@course, @course_offering),
        notice: I18n.t("enrollments.completed")
    else
      redirect_to course_course_offering_path(@course, @course_offering),
        alert: result.reason
    end
  end

  def destroy
    @enrollment.withdraw!
    redirect_to course_course_offering_path(@course, @course_offering),
      notice: I18n.t("enrollments.withdrawn")
  end

  private

  def set_course_and_offering
    @course = current_organization.courses.find_by!(slug: params[:course_id])
    @course_offering = @course.course_offerings.find_by!(slug: params[:course_offering_id])
  end

  def set_enrollment
    @enrollment = @course_offering.enrollments.find_by!(slug: params[:id])
    authorize @enrollment
  end

  def enrollment_params
    params.require(:enrollment).permit(:customer_id, :status, :paid, :notes)
  end
end
