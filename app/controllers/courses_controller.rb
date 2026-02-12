# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :set_course, only: [ :show, :edit, :update, :destroy ]

  def index
    @courses = policy_scope(current_organization.courses)

    @courses = @courses.by_agency(params[:agency]) if params[:agency].present?
    @courses = @courses.by_type(params[:course_type]) if params[:course_type].present?
    @courses = @courses.order(:name)
  end

  def show
    @course_offerings = @course.course_offerings.order(start_date: :desc)
  end

  def new
    @course = current_organization.courses.build
    authorize @course
  end

  def create
    @course = current_organization.courses.build(course_params)
    authorize @course

    if @course.save
      redirect_to @course, notice: I18n.t("courses.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @course.update(course_params)
      redirect_to @course, notice: I18n.t("courses.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @course.destroy
      redirect_to courses_path, notice: I18n.t("courses.deleted")
    else
      redirect_to @course, alert: @course.errors.full_messages.to_sentence
    end
  end

  private

  def set_course
    @course = current_organization.courses.find(params[:id])
    authorize @course
  end

  def course_params
    params.require(:course).permit(
      :name, :description, :agency, :level, :course_type,
      :min_age, :max_students, :duration_days,
      :price_cents, :price_currency, :prerequisites_description, :active
    )
  end
end
