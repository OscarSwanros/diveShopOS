# frozen_string_literal: true

class UserInvitationsController < ApplicationController
  def new
    authorize UserInvitation
  end

  def create
    authorize UserInvitation

    result = Onboarding::InviteStaffMember.new(
      organization: current_organization,
      invited_by: current_user,
      name: params[:name],
      email: params[:email],
      role: params[:role] || :staff
    ).call

    if result.success
      redirect_to users_path, notice: I18n.t("onboarding.invitation.sent")
    else
      flash.now[:alert] = result.error
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @invitation = current_organization.user_invitations.find(params[:id])
    authorize @invitation

    @invitation.destroy
    redirect_to users_path, notice: I18n.t("onboarding.invitation.revoked")
  end
end
