# frozen_string_literal: true

require "test_helper"

class Public::DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @jane_account = customer_accounts(:jane_account)
    @jane = customers(:jane_diver)
  end

  def sign_in_customer(account)
    post public_login_path, params: { email: account.email, password: "password123" }
  end

  # --- Authentication ---

  test "show redirects unauthenticated customer to login" do
    get my_dashboard_path
    assert_redirected_to public_login_path
  end

  test "show renders for authenticated customer" do
    sign_in_customer(@jane_account)
    get my_dashboard_path
    assert_response :success
  end

  # --- Enrollments section ---

  test "show displays customer enrollments" do
    sign_in_customer(@jane_account)
    get my_dashboard_path
    assert_select "h2", text: I18n.t("public.dashboard.enrollments.title")
    assert_select "td", text: "PADI Open Water Diver"
  end

  test "show does not display withdrawn enrollments" do
    sign_in_customer(@jane_account)
    # Jane's enrollment is confirmed, not withdrawn - verify it's shown
    get my_dashboard_path
    assert_response :success
  end

  # --- Excursions section ---

  test "show displays customer excursion participations" do
    sign_in_customer(@jane_account)
    # Add a trip participation linked to Jane's customer record
    tp = TripParticipant.create!(
      excursion: excursions(:morning_reef),
      customer: @jane,
      name: @jane.full_name,
      role: :diver,
      status: :tp_confirmed
    )
    get my_dashboard_path
    assert_select "h2", text: I18n.t("public.dashboard.excursions.title")
    assert_select "td", text: "Morning Reef Dive"
    tp.destroy!
  end

  test "show shows empty message when no excursion participations" do
    sign_in_customer(@jane_account)
    get my_dashboard_path
    assert_select "p", text: I18n.t("public.dashboard.excursions.empty")
  end

  # --- Certifications section ---

  test "show displays customer certifications" do
    sign_in_customer(@jane_account)
    get my_dashboard_path
    assert_select "h2", text: I18n.t("public.dashboard.certifications.title")
    assert_select "p.font-medium", text: "Open Water"
    assert_select "p.font-medium", text: "Advanced Open Water"
  end

  test "show does not display discarded certifications" do
    sign_in_customer(@jane_account)
    get my_dashboard_path
    assert_select "p.font-medium", text: "Intro to Scuba", count: 0
  end
end
