# frozen_string_literal: true

module Onboarding
  class InvitationAcceptancesController < ApplicationController
    skip_before_action :require_authentication
    layout "onboarding"

    def new
      @invitation = UserInvitation.find_by_token(params[:token])

      unless @invitation&.pending?
        flash[:alert] = I18n.t("onboarding.invitation.errors.invalid_or_expired")
        redirect_to new_session_path
      end
    end

    def create
      result = Onboarding::AcceptInvitation.new(
        token: params[:token],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      ).call

      if result.success
        session[:user_id] = result.user.id
        redirect_to root_path, notice: I18n.t("onboarding.invitation.accepted")
      else
        @invitation = UserInvitation.find_by_token(params[:token])
        flash.now[:alert] = result.error
        render :new, status: :unprocessable_entity
      end
    end
  end
end
