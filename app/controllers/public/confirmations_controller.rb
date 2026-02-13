# frozen_string_literal: true

module Public
  class ConfirmationsController < Public::BaseController
    def show
      account = current_organization&.customer_accounts&.find_by(confirmation_token: params[:token])

      if account.nil?
        redirect_to public_login_path, alert: I18n.t("public.confirmations.invalid_token")
      elsif account.confirmed?
        redirect_to public_login_path, notice: I18n.t("public.confirmations.already_confirmed")
      else
        account.confirm!
        redirect_to public_login_path, notice: I18n.t("public.confirmations.confirmed")
      end
    end

    def pending
      @email = params[:email]
    end

    def resend
      account = current_organization&.customer_accounts&.find_by(email: params[:email]&.strip&.downcase)

      if account && !account.confirmed?
        account.generate_confirmation_token!
        CustomerAccountMailer.email_confirmation(account).deliver_later
      end

      # Always show success to prevent email enumeration
      redirect_to public_confirmation_pending_path(email: params[:email]),
        notice: I18n.t("public.confirmations.resent")
    end
  end
end
