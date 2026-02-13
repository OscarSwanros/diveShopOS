# frozen_string_literal: true

module Api
  module V1
    class CourseOfferingsController < BaseController
      include ApiPagination

      before_action :set_course
      before_action :set_course_offering, only: [ :show, :update, :destroy ]

      def index
        @course_offerings = paginate(@course.course_offerings.order(start_date: :desc))
      end

      def show
      end

      def create
        @course_offering = @course.course_offerings.build(course_offering_params)
        @course_offering.organization = current_organization
        authorize @course_offering

        if @course_offering.save
          render :show, status: :created
        else
          render_validation_errors(@course_offering)
        end
      end

      def update
        if @course_offering.update(course_offering_params)
          render :show
        else
          render_validation_errors(@course_offering)
        end
      end

      def destroy
        if @course_offering.destroy
          head :no_content
        else
          render_validation_errors(@course_offering)
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
  end
end
