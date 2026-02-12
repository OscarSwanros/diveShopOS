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
end
