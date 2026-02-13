# frozen_string_literal: true

module DashboardHelper
  def dashboard_greeting(user)
    hour = Time.current.in_time_zone(current_organization.time_zone).hour
    key = case hour
    when 5..11 then "morning"
    when 12..16 then "afternoon"
    when 17..20 then "evening"
    else "night"
    end
    t("dashboard.greeting.#{key}", name: user.name)
  end
end
