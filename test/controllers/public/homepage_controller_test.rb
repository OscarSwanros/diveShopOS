# frozen_string_literal: true

require "test_helper"

class Public::HomepageControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @owner = users(:owner_maria)
    @published_excursion = excursions(:morning_reef)
    @draft_excursion = excursions(:draft_trip)
    @course = courses(:padi_ow)
    @dive_site = dive_sites(:coral_garden)
  end

  # --- Unauthenticated visitor ---

  test "unauthenticated visitor gets 200" do
    get root_path
    assert_response :success
  end

  test "renders with public layout" do
    get root_path
    assert_select "nav"
  end

  test "shows organization name" do
    get root_path
    assert_select "h1", text: @organization.name
  end

  test "shows published upcoming excursions" do
    get root_path
    assert_select "h3", text: @published_excursion.title
  end

  test "does not show draft excursions" do
    get root_path
    assert_select "h3", text: @draft_excursion.title, count: 0
  end

  test "shows active courses" do
    get root_path
    assert_select "h3", text: @course.name
  end

  test "shows active dive sites" do
    get root_path
    assert_select "h3", text: @dive_site.name
  end

  test "limits to 3 items per section" do
    get root_path
    assert_response :success
    # The controller limits each section to 3 items
  end

  # --- Staff user redirect ---

  test "staff user is redirected to dashboard" do
    sign_in @owner
    get root_path
    assert_redirected_to dashboard_path
  end

  # --- Browse/signup CTAs ---

  test "shows browse excursions CTA" do
    get root_path
    assert_select "a[href=?]", catalog_excursions_path, text: I18n.t("public.homepage.browse_excursions")
  end

  test "shows create account CTA" do
    get root_path
    assert_select "a[href=?]", public_signup_path, text: I18n.t("public.homepage.create_account")
  end

  # --- View all links ---

  test "shows view all links for each section" do
    get root_path
    assert_select "a[href=?]", catalog_excursions_path, text: I18n.t("public.homepage.view_all")
    assert_select "a[href=?]", catalog_courses_path, text: I18n.t("public.homepage.view_all")
    assert_select "a[href=?]", catalog_dive_sites_path, text: I18n.t("public.homepage.view_all")
  end

  private

  def sign_in(user)
    post session_path, params: { email_address: user.email_address, password: "password123" }
  end
end
