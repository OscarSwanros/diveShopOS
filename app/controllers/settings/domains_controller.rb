# frozen_string_literal: true

module Settings
  class DomainsController < ApplicationController
    before_action :authorize_owner

    def show
      @organization = current_organization
      @platform_domain = Rails.application.config.x.platform_domain
    end

    def update
      @organization = current_organization

      if @organization.update(domain_params)
        redirect_to settings_domain_path, notice: I18n.t("settings.domain.updated")
      else
        @platform_domain = Rails.application.config.x.platform_domain
        render :show, status: :unprocessable_entity
      end
    end

    def verify
      @organization = current_organization
      @result = ::Settings::VerifyDns.new(organization: @organization).call

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "dns_verification_result",
            partial: "settings/domains/verification_result",
            locals: { result: @result }
          )
        end
        format.html { redirect_to settings_domain_path }
      end
    end

    private

    def authorize_owner
      authorize :settings, :domain?
    end

    def domain_params
      params.require(:organization).permit(:custom_domain)
    end
  end
end
