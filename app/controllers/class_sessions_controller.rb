# frozen_string_literal: true

class ClassSessionsController < ApplicationController
  before_action :set_course_and_offering
  before_action :set_class_session, only: [ :show, :edit, :update, :destroy ]

  def show
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
    if @class_session.update(class_session_params)
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
    @course = current_organization.courses.find(params[:course_id])
    @course_offering = @course.course_offerings.find(params[:course_offering_id])
  end

  def set_class_session
    @class_session = @course_offering.class_sessions.find(params[:id])
    authorize @class_session
  end

  def class_session_params
    params.require(:class_session).permit(
      :session_type, :title, :scheduled_date, :start_time, :end_time,
      :location_description, :dive_site_id, :notes
    )
  end
end
