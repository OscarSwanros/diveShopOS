# frozen_string_literal: true

module Api
  module V1
    class CoursesController < BaseController
      include ApiPagination

      before_action :set_course, only: [ :show, :update, :destroy ]

      def index
        scope = policy_scope(current_organization.courses)
        scope = scope.by_agency(params[:agency]) if params[:agency].present?
        scope = scope.by_type(params[:course_type]) if params[:course_type].present?
        @courses = paginate(scope.order(:name))
      end

      def show
      end

      def create
        @course = current_organization.courses.build(course_params)
        authorize @course

        if @course.save
          render :show, status: :created
        else
          render_validation_errors(@course)
        end
      end

      def update
        if @course.update(course_params)
          render :show
        else
          render_validation_errors(@course)
        end
      end

      def destroy
        if @course.destroy
          head :no_content
        else
          render_validation_errors(@course)
        end
      end

      private

      def set_course
        @course = find_by_slug_or_id(current_organization.courses, params[:id])
        authorize @course
      end

      def course_params
        params.require(:course).permit(
          :name, :description, :agency, :level, :course_type,
          :min_age, :max_students, :duration_days,
          :price, :price_cents, :price_currency, :prerequisites_description, :active
        )
      end
    end
  end
end
