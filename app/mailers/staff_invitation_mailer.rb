# frozen_string_literal: true

class StaffInvitationMailer < ApplicationMailer
  def invite(invitation, token)
    @invitation = invitation
    @organization = invitation.organization
    @accept_url = accept_invitation_url(token: token, host: mailer_host)

    mail(
      to: invitation.email,
      subject: I18n.t("staff_invitation_mailer.invite.subject", organization: @organization.name)
    )
  end

  private

  def mailer_host
    if @organization.custom_domain.present?
      @organization.custom_domain
    elsif @organization.subdomain.present?
      if Rails.env.development? || Rails.env.test?
        "#{@organization.subdomain}.lvh.me"
      else
        "#{@organization.subdomain}.diveshopos.com"
      end
    else
      "diveshopos.com"
    end
  end
end
