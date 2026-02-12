# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :require_authentication

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def require_authentication
    resume_session || redirect_to_login
  end

  def resume_session
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
    Current.organization = Current.user&.organization
    Current.user
  end

  def redirect_to_login
    redirect_to new_session_path, alert: I18n.t("sessions.please_sign_in")
  end

  def current_user
    Current.user
  end

  def current_organization
    Current.organization
  end

  helper_method :current_user, :current_organization

  def pundit_user
    current_user
  end
end
