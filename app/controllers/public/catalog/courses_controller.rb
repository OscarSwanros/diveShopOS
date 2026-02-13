# frozen_string_literal: true

module Public
  module Catalog
    class CoursesController < Public::BaseController
      def index
        @courses = current_organization.courses
          .active
          .includes(:course_offerings)
          .order(:name)
      end

      def show
        @course = current_organization.courses
          .active
          .find_by!(slug: params[:id])
        @offerings = @course.course_offerings.published_upcoming.includes(:instructor)
      end
    end
  end
end
