# frozen_string_literal: true

module Public
  class PasswordResetsController < Public::BaseController
    def new
    end

    def create
      account = current_organization&.customer_accounts&.find_by(email: params[:email]&.strip&.downcase)

      if account
        @reset_token = account.password_reset_token
        CustomerAccountMailer.password_reset(account, @reset_token).deliver_later
      end

      # Always show success to prevent email enumeration
      redirect_to public_login_path, notice: I18n.t("public.password_resets.sent")
    end

    def edit
      @account = find_account_by_reset_token(params[:token])

      unless @account
        redirect_to public_forgot_password_path, alert: I18n.t("public.password_resets.invalid_token")
      end
    end

    def update
      @account = find_account_by_reset_token(params[:token])

      unless @account
        redirect_to public_forgot_password_path, alert: I18n.t("public.password_resets.invalid_token")
        return
      end

      if @account.update(password: params[:password], password_confirmation: params[:password_confirmation])
        redirect_to public_login_path, notice: I18n.t("public.password_resets.updated")
      else
        flash.now[:alert] = @account.errors.full_messages.join(", ")
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def find_account_by_reset_token(token)
      return nil if token.blank?

      account = CustomerAccount.find_by_token_for(:password_reset, token)
      # Ensure the account belongs to the current organization
      account if account&.organization == current_organization
    end
  end
end
