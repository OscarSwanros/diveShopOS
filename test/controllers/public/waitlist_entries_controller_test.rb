# frozen_string_literal: true

require "test_helper"

class Public::WaitlistEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:reef_divers)
    @jane_account = customer_accounts(:jane_account)
    @jane = customers(:jane_diver)
    @full_excursion = excursions(:full_trip)
  end

  def sign_in_customer(account)
    post public_login_path, params: { email: account.email, password: "password123" }
  end

  # --- Authentication ---

  test "create redirects unauthenticated customer to login" do
    post waitlist_entries_path, params: { waitlistable_type: "Excursion", waitlistable_id: @full_excursion.id }
    assert_redirected_to public_login_path
  end

  test "destroy redirects unauthenticated customer to login" do
    delete waitlist_entry_path("some-slug")
    assert_redirected_to public_login_path
  end

  # --- Create ---

  test "create adds customer to waitlist for excursion" do
    sign_in_customer(@jane_account)

    assert_difference "WaitlistEntry.count", 1 do
      post waitlist_entries_path, params: {
        waitlistable_type: "Excursion",
        waitlistable_id: @full_excursion.id
      }
    end

    assert_redirected_to catalog_excursion_path(@full_excursion)
    follow_redirect!
    assert_equal I18n.t("public.waitlist.joined"), flash[:notice]
  end

  test "create rejects duplicate waitlist entry" do
    sign_in_customer(@jane_account)

    # First join
    post waitlist_entries_path, params: {
      waitlistable_type: "Excursion",
      waitlistable_id: @full_excursion.id
    }

    # Duplicate
    assert_no_difference "WaitlistEntry.count" do
      post waitlist_entries_path, params: {
        waitlistable_type: "Excursion",
        waitlistable_id: @full_excursion.id
      }
    end

    assert_redirected_to catalog_excursion_path(@full_excursion)
  end

  test "create sends waitlist confirmation email" do
    sign_in_customer(@jane_account)

    assert_enqueued_emails 1 do
      post waitlist_entries_path, params: {
        waitlistable_type: "Excursion",
        waitlistable_id: @full_excursion.id
      }
    end
  end

  # --- Destroy ---

  test "destroy cancels waitlist entry" do
    sign_in_customer(@jane_account)

    entry = WaitlistEntry.create!(
      organization: @organization,
      customer: @jane,
      waitlistable: @full_excursion,
      position: 1
    )

    delete waitlist_entry_path(entry)

    assert_redirected_to catalog_excursion_path(@full_excursion)
    entry.reload
    assert entry.cancelled?
  end

  test "destroy returns 404 for another customer's entry" do
    sign_in_customer(@jane_account)
    bob = customers(:bob_bubbles)

    entry = WaitlistEntry.create!(
      organization: @organization,
      customer: bob,
      waitlistable: @full_excursion,
      position: 1
    )

    delete waitlist_entry_path(entry)
    assert_response :not_found
  end
end
