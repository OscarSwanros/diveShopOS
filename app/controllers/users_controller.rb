# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @users = policy_scope(current_organization.users).order(:name)
  end

  def show
    @instructor_ratings = @user.instructor_ratings.order(created_at: :desc)
  end

  def new
    @user = current_organization.users.build
    authorize @user
  end

  def create
    @user = current_organization.users.build(user_params)
    authorize @user

    if @user.save
      redirect_to @user, notice: I18n.t("users.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    attrs = user_params
    attrs = attrs.except(:password, :password_confirmation) if attrs[:password].blank?

    if @user.update(attrs)
      redirect_to @user, notice: I18n.t("users.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to users_path, notice: I18n.t("users.deleted")
  end

  private

  def set_user
    @user = current_organization.users.find(params[:id])
    authorize @user
  end

  def user_params
    permitted = params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
    permitted[:role] = params[:user][:role] if current_user.owner? && params[:user][:role].present?
    permitted
  end
end
