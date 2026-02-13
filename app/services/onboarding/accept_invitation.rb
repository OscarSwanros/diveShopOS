# frozen_string_literal: true

module Onboarding
  class AcceptInvitation
    Result = Data.define(:success, :user, :error)

    def initialize(token:, password:, password_confirmation:)
      @token = token
      @password = password
      @password_confirmation = password_confirmation
    end

    def call
      invitation = UserInvitation.find_by_token(@token)

      unless invitation
        return Result.new(success: false, user: nil,
          error: I18n.t("onboarding.invitation.errors.invalid_token"))
      end

      if invitation.accepted?
        return Result.new(success: false, user: nil,
          error: I18n.t("onboarding.invitation.errors.already_accepted"))
      end

      if invitation.expired?
        return Result.new(success: false, user: nil,
          error: I18n.t("onboarding.invitation.errors.expired"))
      end

      ActiveRecord::Base.transaction do
        user = User.create!(
          organization: invitation.organization,
          name: invitation.name,
          email_address: invitation.email,
          password: @password,
          password_confirmation: @password_confirmation,
          role: invitation.role
        )

        invitation.update!(accepted_at: Time.current)

        Result.new(success: true, user: user, error: nil)
      end
    rescue ActiveRecord::RecordInvalid => e
      Result.new(success: false, user: nil, error: e.record.errors.full_messages.join(", "))
    end
  end
end
