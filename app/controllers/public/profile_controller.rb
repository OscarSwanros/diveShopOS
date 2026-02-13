# frozen_string_literal: true

module Public
  class ProfileController < Public::BaseController
    before_action :require_customer_authentication
    before_action :set_customer

    def show
    end

    def edit
    end

    def update
      if @customer.update(customer_params)
        redirect_to my_profile_path, notice: I18n.t("public.profile.updated")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_customer
      @customer = current_customer_account.customer
    end

    def customer_params
      params.require(:customer).permit(
        :first_name, :last_name, :phone, :date_of_birth,
        :emergency_contact_name, :emergency_contact_phone
      )
    end
  end
end
