# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :require_authentication
  before_action :load_review_queue_count

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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

  def user_not_authorized
    respond_to do |format|
      format.html { head :forbidden }
      format.json { head :forbidden }
    end
  end

  def load_review_queue_count
    return unless current_user && current_organization

    enrollment_count = Enrollment
      .joins(:course_offering)
      .where(course_offerings: { organization_id: current_organization.id })
      .review_queue
      .count

    participant_count = TripParticipant
      .joins(:excursion)
      .where(excursions: { organization_id: current_organization.id })
      .review_queue
      .count

    @review_queue_count = enrollment_count + participant_count
  end
end
