# frozen_string_literal: true

module Settings
  class BrandingsController < ApplicationController
    before_action :authorize_owner

    def show
      @organization = current_organization
    end

    def update
      @organization = current_organization

      if @organization.update(branding_params)
        redirect_to settings_branding_path, notice: I18n.t("settings.branding.updated")
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def authorize_owner
      authorize :settings, :branding?
    end

    def branding_params
      params.require(:organization).permit(
        :brand_primary_color, :brand_accent_color, :tagline,
        :logo, :favicon, :phone, :contact_email, :address,
        social_links: %i[facebook instagram youtube]
      )
    end
  end
end
