# frozen_string_literal: true

class CaddyController < ActionController::Base
  def ask
    domain = params[:domain].to_s.strip.downcase

    if domain.present? && Organization.exists?(custom_domain: domain)
      head :ok
    else
      head :not_found
    end
  end
end
