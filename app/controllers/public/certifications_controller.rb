# frozen_string_literal: true

module Public
  class CertificationsController < Public::BaseController
    before_action :require_customer_authentication

    def index
      @certifications = current_customer_account.customer.certifications.kept.order(issued_date: :desc)
    end

    def new
      @certification = current_customer_account.customer.certifications.build
    end

    def create
      @certification = current_customer_account.customer.certifications.build(certification_params)

      if @certification.save
        redirect_to my_certifications_path, notice: I18n.t("public.certifications.created")
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def certification_params
      params.require(:certification).permit(
        :agency, :certification_level, :certification_number, :issued_date
      )
    end
  end
end
