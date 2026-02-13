# frozen_string_literal: true

module Api
  module V1
    class InstructorRatingsController < BaseController
      include ApiPagination

      before_action :set_instructor_rating, only: [ :show, :update, :destroy ]

      def index
        @instructor_ratings = paginate(policy_scope(InstructorRating).includes(:user).order("users.name"))
      end

      def show
      end

      def create
        @instructor_rating = InstructorRating.new(instructor_rating_params)
        authorize @instructor_rating

        if @instructor_rating.save
          render :show, status: :created
        else
          render_validation_errors(@instructor_rating)
        end
      end

      def update
        if @instructor_rating.update(instructor_rating_params)
          render :show
        else
          render_validation_errors(@instructor_rating)
        end
      end

      def destroy
        @instructor_rating.destroy
        head :no_content
      end

      private

      def set_instructor_rating
        @instructor_rating = find_by_slug_or_id(policy_scope(InstructorRating), params[:id])
        authorize @instructor_rating
      end

      def instructor_rating_params
        params.require(:instructor_rating).permit(
          :user_id, :agency, :rating_level, :rating_number, :active, :expiration_date
        )
      end
    end
  end
end
