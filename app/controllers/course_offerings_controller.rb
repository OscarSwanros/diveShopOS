# frozen_string_literal: true

class CourseOfferingsController < ApplicationController
  before_action :set_course
  before_action :set_course_offering, only: [ :show, :edit, :update, :destroy ]

  def show
    @class_sessions = @course_offering.class_sessions.by_date
    @enrollments = @course_offering.enrollments.includes(:customer).order("customers.last_name")
  end

  def new
    @course_offering = @course.course_offerings.build(
      organization: current_organization,
      max_students: @course.max_students,
      start_date: Date.current
    )
    authorize @course_offering
  end

  def create
    @course_offering = @course.course_offerings.build(course_offering_params)
    @course_offering.organization = current_organization
    authorize @course_offering

    if @course_offering.save
      redirect_to course_course_offering_path(@course, @course_offering),
        notice: I18n.t("course_offerings.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @course_offering.update(course_offering_params)
      redirect_to course_course_offering_path(@course, @course_offering),
        notice: I18n.t("course_offerings.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @course_offering.destroy
      redirect_to course_path(@course), notice: I18n.t("course_offerings.deleted")
    else
      redirect_to course_course_offering_path(@course, @course_offering),
        alert: @course_offering.errors.full_messages.to_sentence
    end
  end

  private

  def set_course
    @course = current_organization.courses.find(params[:course_id])
  end

  def set_course_offering
    @course_offering = @course.course_offerings.find(params[:id])
    authorize @course_offering
  end

  def course_offering_params
    params.require(:course_offering).permit(
      :instructor_id, :start_date, :end_date, :max_students,
      :price_cents, :price_currency, :status, :notes
    )
  end
end
