# frozen_string_literal: true

class InstructorRatingsController < ApplicationController
  before_action :set_instructor_rating, only: [ :edit, :update, :destroy ]

  def index
    @instructor_ratings = policy_scope(InstructorRating).includes(:user).order("users.name")
  end

  def new
    @instructor_rating = InstructorRating.new
    authorize @instructor_rating
  end

  def create
    @instructor_rating = InstructorRating.new(instructor_rating_params)
    authorize @instructor_rating

    if @instructor_rating.save
      redirect_to instructor_ratings_path, notice: I18n.t("instructor_ratings.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @instructor_rating.update(instructor_rating_params)
      redirect_to instructor_ratings_path, notice: I18n.t("instructor_ratings.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @instructor_rating.destroy
    redirect_to instructor_ratings_path, notice: I18n.t("instructor_ratings.deleted")
  end

  private

  def set_instructor_rating
    @instructor_rating = policy_scope(InstructorRating).find(params[:id])
    authorize @instructor_rating
  end

  def instructor_rating_params
    params.require(:instructor_rating).permit(
      :user_id, :agency, :rating_level, :rating_number, :active, :expiration_date
    )
  end
end
