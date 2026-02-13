# frozen_string_literal: true

require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  test "valid organization" do
    org = Organization.new(name: "Aqua Dive School", slug: "aqua-dive")
    assert org.valid?
  end

  test "requires name" do
    org = Organization.new(slug: "test-shop")
    assert_not org.valid?
    assert_includes org.errors[:name], "can't be blank"
  end

  test "requires slug" do
    org = Organization.new(name: "Test Shop")
    assert_not org.valid?
    assert_includes org.errors[:slug], "can't be blank"
  end

  test "slug must be unique" do
    Organization.create!(name: "Shop One", slug: "same-slug")
    org = Organization.new(name: "Shop Two", slug: "same-slug")
    assert_not org.valid?
    assert_includes org.errors[:slug], "has already been taken"
  end

  test "slug format allows lowercase, numbers, and hyphens" do
    org = Organization.new(name: "Test", slug: "valid-slug-123")
    assert org.valid?

    org.slug = "Invalid Slug"
    assert_not org.valid?

    org.slug = "UPPERCASE"
    assert_not org.valid?
  end

  test "custom_domain must be unique when present" do
    Organization.create!(name: "Shop One", slug: "shop-1", custom_domain: "shop1.com")
    org = Organization.new(name: "Shop Two", slug: "shop-2", custom_domain: "shop1.com")
    assert_not org.valid?
    assert_includes org.errors[:custom_domain], "has already been taken"
  end

  test "multiple organizations can have nil custom_domain" do
    Organization.create!(name: "Shop One", slug: "shop-1", custom_domain: nil)
    org = Organization.new(name: "Shop Two", slug: "shop-2", custom_domain: nil)
    assert org.valid?
  end

  test "generates UUID primary key" do
    org = Organization.create!(name: "Test Shop", slug: "test-shop")
    assert_match(/\A[0-9a-f-]{36}\z/, org.id)
  end

  test "defaults locale to en" do
    org = Organization.new(name: "Test", slug: "test")
    assert_equal "en", org.locale
  end

  test "defaults time_zone to UTC" do
    org = Organization.new(name: "Test", slug: "test")
    assert_equal "UTC", org.time_zone
  end

  # --- Subdomain ---

  test "auto-assigns subdomain from slug on create" do
    org = Organization.create!(name: "New Shop", slug: "new-shop")
    assert_equal "new-shop", org.subdomain
  end

  test "does not overwrite existing subdomain on create" do
    org = Organization.create!(name: "New Shop", slug: "new-shop", subdomain: "custom-sub")
    assert_equal "custom-sub", org.subdomain
  end

  test "does not change subdomain on update" do
    org = Organization.create!(name: "New Shop", slug: "new-shop")
    org.update!(name: "Updated Name")
    assert_equal "new-shop", org.subdomain
  end

  test "rejects reserved subdomains" do
    Organization::RESERVED_SUBDOMAINS.each do |reserved|
      org = Organization.new(name: "Test", slug: "test-#{reserved}", subdomain: reserved)
      assert_not org.valid?, "Should reject reserved subdomain: #{reserved}"
      assert_includes org.errors[:subdomain], I18n.t("activerecord.errors.models.organization.attributes.subdomain.reserved")
    end
  end

  # --- Custom Domain Normalization ---

  test "normalizes custom domain by stripping https" do
    org = Organization.new(name: "Test", slug: "norm-https", custom_domain: "https://www.myshop.com")
    assert_equal "www.myshop.com", org.custom_domain
  end

  test "normalizes custom domain by stripping http" do
    org = Organization.new(name: "Test", slug: "norm-http", custom_domain: "http://www.myshop.com")
    assert_equal "www.myshop.com", org.custom_domain
  end

  test "normalizes custom domain by stripping paths" do
    org = Organization.new(name: "Test", slug: "norm-path", custom_domain: "www.myshop.com/page/thing")
    assert_equal "www.myshop.com", org.custom_domain
  end

  test "normalizes custom domain by stripping ports" do
    org = Organization.new(name: "Test", slug: "norm-port", custom_domain: "www.myshop.com:8080")
    assert_equal "www.myshop.com", org.custom_domain
  end

  test "normalizes custom domain by downcasing" do
    org = Organization.new(name: "Test", slug: "norm-case", custom_domain: "WWW.MyShop.COM")
    assert_equal "www.myshop.com", org.custom_domain
  end

  test "normalizes custom domain by stripping whitespace" do
    org = Organization.new(name: "Test", slug: "norm-ws", custom_domain: "  www.myshop.com  ")
    assert_equal "www.myshop.com", org.custom_domain
  end

  test "normalizes blank custom domain to nil" do
    org = Organization.new(name: "Test", slug: "norm-blank", custom_domain: "")
    assert_nil org.custom_domain
  end

  test "normalizes full URL to domain" do
    org = Organization.new(name: "Test", slug: "norm-full", custom_domain: "https://www.myshop.com:443/about?q=1")
    assert_equal "www.myshop.com", org.custom_domain
  end

  # --- Custom Domain Format Validation ---

  test "accepts valid custom domain" do
    org = Organization.new(name: "Test", slug: "valid-domain", custom_domain: "www.myshop.com")
    assert org.valid?
  end

  test "accepts domain without www" do
    org = Organization.new(name: "Test", slug: "no-www", custom_domain: "myshop.com")
    assert org.valid?
  end

  test "accepts subdomain custom domain" do
    org = Organization.new(name: "Test", slug: "subdomain", custom_domain: "shop.example.co.uk")
    assert org.valid?
  end

  test "rejects custom domain with spaces" do
    org = Organization.new(name: "Test", slug: "bad-spaces")
    org.custom_domain = "not a domain.com"
    # Normalization will handle it but the resulting value should be checked
    # After normalization: "not a domain.com" -> stripped -> first split by "/" -> "not a domain.com"
    # This should fail validation
    assert_not org.valid?
  end

  test "allows nil custom domain" do
    org = Organization.new(name: "Test", slug: "nil-domain", custom_domain: nil)
    assert org.valid?
  end
end
