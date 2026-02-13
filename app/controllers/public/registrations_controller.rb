# frozen_string_literal: true

module Public
  class RegistrationsController < Public::BaseController
    def new
      redirect_to my_dashboard_path if customer_signed_in?
    end

    def create
      result = Public::CreateCustomerAccount.new(
        organization: current_organization,
        email: registration_params[:email],
        password: registration_params[:password],
        password_confirmation: registration_params[:password_confirmation],
        first_name: registration_params[:first_name],
        last_name: registration_params[:last_name]
      ).call

      if result.success
        CustomerAccountMailer.email_confirmation(result.customer_account).deliver_later
        redirect_to public_confirmation_pending_path(email: result.customer_account.email),
          notice: I18n.t("public.registrations.created")
      else
        flash.now[:alert] = result.error
        render :new, status: :unprocessable_entity
      end
    end

    private

    def registration_params
      params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
  end
end
