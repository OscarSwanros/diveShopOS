# frozen_string_literal: true

module Public
  class BaseController < ApplicationController
    skip_before_action :require_authentication
    before_action :set_customer_account_from_session

    layout "public"

    helper_method :current_customer_account, :customer_signed_in?

    private

    def set_customer_account_from_session
      if session[:customer_account_id] && current_organization
        Current.customer_account = current_organization.customer_accounts.find_by(id: session[:customer_account_id])
        # Clear stale session if account not found
        session.delete(:customer_account_id) unless Current.customer_account
      end
    end

    def current_customer_account
      Current.customer_account
    end

    def customer_signed_in?
      current_customer_account.present?
    end

    def require_customer_authentication
      unless customer_signed_in?
        store_customer_location
        redirect_to public_login_path, alert: I18n.t("public.sessions.please_sign_in")
      end
    end

    def store_customer_location
      session[:customer_return_to] = request.fullpath if request.get? || request.head?
    end
  end
end
