# frozen_string_literal: true

module Api
  module V1
    class SessionAttendancesController < BaseController
      before_action :set_context

      def batch_update
        authorize SessionAttendance

        updated = []
        attendance_params[:attendances].each do |attendance_update|
          attendance = @class_session.session_attendances.find(attendance_update[:id])
          attendance.update!(attended: attendance_update[:attended])
          updated << attendance
        end

        @attendances = @class_session.session_attendances
          .includes(enrollment: :customer)
          .order("customers.last_name, customers.first_name")
          .references(:customers)

        render :batch_update
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
  end
end
