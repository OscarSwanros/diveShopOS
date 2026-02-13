# frozen_string_literal: true

module Onboarding
  class InviteStaffMember
    Result = Data.define(:success, :invitation, :error)

    def initialize(organization:, invited_by:, name:, email:, role: :staff)
      @organization = organization
      @invited_by = invited_by
      @name = name
      @email = email.to_s.strip.downcase
      @role = role
    end

    def call
      existing = UserInvitation.pending.find_by(organization: @organization, email: @email)
      if existing
        return Result.new(success: false, invitation: nil,
          error: I18n.t("onboarding.invitation.errors.already_invited"))
      end

      existing_user = User.find_by(organization: @organization, email_address: @email)
      if existing_user
        return Result.new(success: false, invitation: nil,
          error: I18n.t("onboarding.invitation.errors.already_staff"))
      end

      token = SecureRandom.urlsafe_base64(32)
      token_digest = Digest::SHA256.hexdigest(token)

      invitation = UserInvitation.create!(
        organization: @organization,
        invited_by: @invited_by,
        name: @name,
        email: @email,
        role: @role,
        token_digest: token_digest,
        expires_at: 7.days.from_now
      )

      StaffInvitationMailer.invite(invitation, token).deliver_later

      Result.new(success: true, invitation: invitation, error: nil)
    rescue ActiveRecord::RecordInvalid => e
      Result.new(success: false, invitation: nil, error: e.record.errors.full_messages.join(", "))
    end
  end
end
