# frozen_string_literal: true

class ClassSessionsController < ApplicationController
  before_action :set_course_and_offering
  before_action :set_class_session, only: [ :show, :edit, :update, :destroy ]

  def show
    ensure_attendance_records
    @attendances = @class_session.session_attendances
      .includes(enrollment: :customer)
      .order("customers.last_name, customers.first_name")
      .references(:customers)
  end

  def new
    @class_session = @course_offering.class_sessions.build(
      scheduled_date: @course_offering.start_date
    )
    authorize @class_session
  end

  def create
    @class_session = @course_offering.class_sessions.build(class_session_params)
    authorize @class_session

    if @class_session.save
      redirect_to course_course_offering_path(@course, @course_offering),
        notice: I18n.t("class_sessions.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    schedule_changed = schedule_changing?

    if @class_session.update(class_session_params)
      notify_reschedule if schedule_changed
      redirect_to course_course_offering_path(@course, @course_offering),
        notice: I18n.t("class_sessions.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @class_session.destroy
    redirect_to course_course_offering_path(@course, @course_offering),
      notice: I18n.t("class_sessions.deleted")
  end

  private

  def set_course_and_offering
    @course = current_organization.courses.find_by!(slug: params[:course_id])
    @course_offering = @course.course_offerings.find_by!(slug: params[:course_offering_id])
  end

  def set_class_session
    @class_session = @course_offering.class_sessions.find_by!(slug: params[:id])
    authorize @class_session
  end

  def class_session_params
    params.require(:class_session).permit(
      :session_type, :title, :scheduled_date, :start_time, :end_time,
      :location_description, :dive_site_id, :notes
    )
  end

  def schedule_changing?
    incoming = class_session_params
    @class_session.scheduled_date.to_s != incoming[:scheduled_date].to_s ||
      @class_session.start_time_before_type_cast.to_s != incoming[:start_time].to_s ||
      @class_session.end_time_before_type_cast.to_s != incoming[:end_time].to_s
  end

  def notify_reschedule
    @course_offering.enrollments.active_enrollments.includes(:customer).each do |enrollment|
      ClassSessionMailer.reschedule_notification(@class_session, enrollment).deliver_later
    end
  end

  def ensure_attendance_records
    active_enrollments = @course_offering.enrollments.active_enrollments
    existing_enrollment_ids = @class_session.session_attendances.pluck(:enrollment_id)

    active_enrollments.each do |enrollment|
      next if existing_enrollment_ids.include?(enrollment.id)
      @class_session.session_attendances.create!(enrollment: enrollment)
    end
  end
end
