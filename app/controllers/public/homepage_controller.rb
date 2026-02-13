# frozen_string_literal: true

module Public
  class HomepageController < Public::BaseController
    def show
      if session[:user_id]
        redirect_to dashboard_path, status: :see_other
        return
      end

      @excursions = current_organization.excursions
        .published_upcoming
        .includes(trip_dives: :dive_site)
        .limit(3)

      @courses = current_organization.courses
        .active
        .includes(:course_offerings)
        .order(:name)
        .limit(3)

      @dive_sites = current_organization.dive_sites
        .active
        .order(:name)
        .limit(3)
    end
  end
end
