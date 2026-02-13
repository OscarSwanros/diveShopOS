# frozen_string_literal: true

module Public
  class SessionsController < Public::BaseController
    def new
      redirect_to my_dashboard_path if customer_signed_in?
    end

    def create
      account = current_organization&.customer_accounts&.find_by(email: session_params[:email]&.strip&.downcase)

      if account&.authenticate(session_params[:password])
        unless account.confirmed?
          redirect_to public_login_path, alert: I18n.t("public.sessions.unconfirmed")
          return
        end

        session[:customer_account_id] = account.id
        account.record_sign_in!(ip: request.remote_ip)
        Current.customer_account = account

        redirect_to session.delete(:customer_return_to) || my_dashboard_path,
          notice: I18n.t("public.sessions.signed_in")
      else
        flash.now[:alert] = I18n.t("public.sessions.invalid_credentials")
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session.delete(:customer_account_id)
      Current.customer_account = nil
      redirect_to catalog_excursions_path, notice: I18n.t("public.sessions.signed_out")
    end

    private

    def session_params
      params.permit(:email, :password)
    end
  end
end
