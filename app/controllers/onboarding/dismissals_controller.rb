# frozen_string_literal: true

module Onboarding
  class DismissalsController < ApplicationController
    def update
      authorize :onboarding, :dismiss?

      current_organization.update!(onboarding_dismissed: true)

      redirect_to root_path
    end
  end
end
