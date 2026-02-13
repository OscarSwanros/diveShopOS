# frozen_string_literal: true

module Onboarding
  class DemoDataController < ApplicationController
    def destroy
      authorize :onboarding, :manage?

      Onboarding::ClearDemoData.new(organization: current_organization).call

      redirect_to root_path, notice: I18n.t("onboarding.demo_banner.cleared")
    end
  end
end
