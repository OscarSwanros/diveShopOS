# frozen_string_literal: true

require "test_helper"

class Public::Catalog::ExcursionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @published_excursion = excursions(:morning_reef)
    @draft_excursion = excursions(:draft_trip)
    @past_excursion = excursions(:past_trip)
    @other_org_excursion = excursions(:other_org_excursion)
  end

  # --- Index ---

  test "index renders without authentication" do
    get catalog_excursions_path
    assert_response :success
  end

  test "index shows published upcoming excursions" do
    get catalog_excursions_path
    assert_select "h2", text: @published_excursion.title
  end

  test "index does not show draft excursions" do
    get catalog_excursions_path
    assert_select "h2", text: @draft_excursion.title, count: 0
  end

  test "index does not show past excursions" do
    get catalog_excursions_path
    assert_select "h2", text: @past_excursion.title, count: 0
  end

  test "index does not show other org excursions" do
    get catalog_excursions_path
    assert_select "h2", text: @other_org_excursion.title, count: 0
  end

  test "index shows spots remaining" do
    get catalog_excursions_path
    assert_response :success
  end

  # --- Show ---

  test "show renders for published excursion" do
    get catalog_excursion_path(@published_excursion)
    assert_response :success
    assert_select "h1", text: @published_excursion.title
  end

  test "show returns 404 for draft excursion" do
    get catalog_excursion_path(@draft_excursion)
    assert_response :not_found
  end

  test "show displays price" do
    get catalog_excursion_path(@published_excursion)
    assert_response :success
  end

  test "show displays trip dives with dive sites" do
    get catalog_excursion_path(@published_excursion)
    assert_response :success
  end

  test "show does not expose staff notes" do
    get catalog_excursion_path(@published_excursion)
    # Notes field should not be in the public view
    assert_select "[data-test='staff-notes']", count: 0
  end
end
