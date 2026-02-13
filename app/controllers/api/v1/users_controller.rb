# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      include ApiPagination

      before_action :set_user, only: [ :show, :update, :destroy ]

      def index
        @users = paginate(policy_scope(current_organization.users).order(:name))
      end

      def show
      end

      def create
        @user = current_organization.users.build(user_params)
        authorize @user

        if @user.save
          render :show, status: :created
        else
          render_validation_errors(@user)
        end
      end

      def update
        attrs = user_params
        attrs = attrs.except(:password, :password_confirmation) if attrs[:password].blank?

        if @user.update(attrs)
          render :show
        else
          render_validation_errors(@user)
        end
      end

      def destroy
        @user.destroy!
        head :no_content
      end

      private

      def set_user
        @user = find_by_slug_or_id(current_organization.users, params[:id])
        authorize @user
      end

      def user_params
        permitted = params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
        permitted[:role] = params[:user][:role] if current_user.owner? && params[:user][:role].present?
        permitted
      end
    end
  end
end
