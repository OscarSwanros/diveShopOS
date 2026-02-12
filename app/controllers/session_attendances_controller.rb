# frozen_string_literal: true

class SessionAttendancesController < ApplicationController
  before_action :set_context

  def batch_update
    authorize SessionAttendance

    attendance_params[:attendances].each do |attendance_update|
      attendance = @class_session.session_attendances.find(attendance_update[:id])
      attendance.update!(attended: attendance_update[:attended] == "1")
    end

    redirect_to course_course_offering_class_session_path(@course, @course_offering, @class_session),
      notice: I18n.t("session_attendances.updated")
  end

  private

  def set_context
    @course = current_organization.courses.find(params[:course_id])
    @course_offering = @course.course_offerings.find(params[:course_offering_id])
    @class_session = @course_offering.class_sessions.find(params[:class_session_id])
  end

  def attendance_params
    params.permit(attendances: [ :id, :attended ])
  end
end
