# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: [ :new, :create ]

  def new
  end

  def create
    user = User.find_by(organization_id: Current.organization&.id, email_address: params[:email_address])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      Current.user = user
      Current.organization = user.organization
      redirect_to root_path, notice: I18n.t("sessions.signed_in")
    else
      flash.now[:alert] = I18n.t("sessions.invalid_credentials")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    Current.user = nil
    Current.organization = nil
    redirect_to new_session_path, notice: I18n.t("sessions.signed_out")
  end
end
