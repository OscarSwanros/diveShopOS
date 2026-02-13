# frozen_string_literal: true

require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = users(:owner_maria)
  end

  # --- Authentication ---

  test "requires authentication" do
    get dashboard_path
    assert_redirected_to new_session_path
  end

  test "renders for authenticated user" do
    sign_in @owner
    get dashboard_path
    assert_response :success
  end

  test "root path loads dashboard" do
    sign_in @owner
    get root_path
    assert_response :success
    assert_select "h1", /#{@owner.name}/
  end

  # --- Today's Schedule ---

  test "displays today's schedule sections" do
    sign_in @owner
    get dashboard_path
    assert_select "h2", text: I18n.t("dashboard.today.excursions")
    assert_select "h2", text: I18n.t("dashboard.today.class_sessions")
  end

  test "shows empty state when no excursions today" do
    sign_in @owner
    get dashboard_path
    assert_select "p", text: I18n.t("dashboard.today.no_excursions")
  end

  # --- Safety Alerts ---

  test "displays safety alerts when alerts exist" do
    sign_in @owner
    get dashboard_path
    assert_select "h2", text: I18n.t("dashboard.safety_alerts.title")
  end

  test "shows equipment overdue alert" do
    sign_in @owner
    get dashboard_path
    assert_select "a[href=?]", equipment_items_path
  end

  test "shows tanks noncompliant alert" do
    sign_in @owner
    get dashboard_path
    assert_select "a[href=?]", customers_path
  end

  # --- Upcoming ---

  test "displays upcoming sections" do
    sign_in @owner
    get dashboard_path
    assert_select "h2", text: I18n.t("dashboard.upcoming.excursions")
    assert_select "h2", text: I18n.t("dashboard.upcoming.offerings")
  end

  test "shows upcoming excursions" do
    sign_in @owner
    get dashboard_path
    # full_trip is published, scheduled_date = Date.current + 3.days (within 7 days)
    assert_select "a", text: excursions(:full_trip).title
  end

  test "shows upcoming offerings" do
    sign_in @owner
    get dashboard_path
    # padi_ow_upcoming starts in 7 days, status: published
    assert_select "a", text: courses(:padi_ow).name
  end

  # --- Quick Stats ---

  test "displays quick stats" do
    sign_in @owner
    get dashboard_path
    assert_select "p", text: I18n.t("dashboard.stats.active_customers")
    assert_select "p", text: I18n.t("dashboard.stats.active_enrollments")
    assert_select "p", text: I18n.t("dashboard.stats.equipment_fleet")
    assert_select "p", text: I18n.t("dashboard.stats.unpaid_trip_spots")
    assert_select "p", text: I18n.t("dashboard.stats.unpaid_enrollments")
  end

  # --- Tenant Isolation ---

  test "only shows data from current organization" do
    sign_in @owner
    get dashboard_path
    # other_org_excursion title should not appear
    assert_select "a", text: excursions(:other_org_excursion).title, count: 0
  end

  private

  def sign_in(user)
    post session_path, params: { email_address: user.email_address, password: "password123" }
  end
end
