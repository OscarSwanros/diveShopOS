# frozen_string_literal: true

require "test_helper"

class Public::Catalog::DiveSitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @active_site = dive_sites(:coral_garden)
    @inactive_site = dive_sites(:inactive_site)
    @other_org_site = dive_sites(:other_org_site)
  end

  # --- Index ---

  test "index renders without authentication" do
    get catalog_dive_sites_path
    assert_response :success
  end

  test "index shows active dive sites" do
    get catalog_dive_sites_path
    assert_select "h2", text: @active_site.name
  end

  test "index does not show inactive dive sites" do
    get catalog_dive_sites_path
    assert_select "h2", text: @inactive_site.name, count: 0
  end

  test "index does not show other org dive sites" do
    get catalog_dive_sites_path
    assert_select "h2", text: @other_org_site.name, count: 0
  end

  # --- Show ---

  test "show renders for active dive site" do
    get catalog_dive_site_path(@active_site)
    assert_response :success
    assert_select "h1", text: @active_site.name
  end

  test "show returns 404 for inactive dive site" do
    get catalog_dive_site_path(@inactive_site)
    assert_response :not_found
  end

  test "show displays dive site details" do
    get catalog_dive_site_path(@active_site)
    assert_response :success
  end

  test "show lists upcoming excursions at this site" do
    get catalog_dive_site_path(@active_site)
    assert_response :success
  end
end
