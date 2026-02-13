# frozen_string_literal: true

module Api
  module V1
    class ClassSessionsController < BaseController
      include ApiPagination

      before_action :set_course_and_offering
      before_action :set_class_session, only: [ :show, :update, :destroy ]

      def index
        @class_sessions = paginate(@course_offering.class_sessions.by_date)
      end

      def show
      end

      def create
        @class_session = @course_offering.class_sessions.build(class_session_params)
        authorize @class_session

        if @class_session.save
          render :show, status: :created
        else
          render_validation_errors(@class_session)
        end
      end

      def update
        schedule_changed = schedule_changing?

        if @class_session.update(class_session_params)
          notify_reschedule if schedule_changed
          render :show
        else
          render_validation_errors(@class_session)
        end
      end

      def destroy
        @class_session.destroy
        head :no_content
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
    end
  end
end
