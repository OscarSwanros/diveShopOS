# frozen_string_literal: true

module Onboarding
  class RegistrationsController < ActionController::Base
    layout "onboarding"

    def new
      # Redirect to dashboard if already signed in
      redirect_to root_path if session[:user_id]
    end

    def create
      result = Onboarding::CreateShop.new(
        shop_name: params[:shop_name],
        owner_name: params[:owner_name],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      ).call

      if result.success
        Onboarding::SeedDemoData.new(organization: result.organization).call

        session[:user_id] = result.user.id
        redirect_to root_url(host: tenant_host(result.organization)), allow_other_host: true
      else
        flash.now[:alert] = result.error
        render :new, status: :unprocessable_entity
      end
    end

    private

    def tenant_host(organization)
      if Rails.env.development? || Rails.env.test?
        "#{organization.subdomain}.lvh.me"
      else
        "#{organization.subdomain}.diveshopos.com"
      end
    end
  end
end
