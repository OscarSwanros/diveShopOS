# frozen_string_literal: true

require "test_helper"

class SluggableTest < ActiveSupport::TestCase
  test "generates slug on create" do
    customer = organizations(:reef_divers).customers.create!(
      first_name: "New",
      last_name: "Diver"
    )
    assert_equal "new-diver", customer.slug
  end

  test "generates slug from symbol source" do
    course = organizations(:reef_divers).courses.create!(
      name: "PADI Rescue Diver",
      agency: "PADI",
      level: "Rescue",
      course_type: :certification,
      max_students: 8,
      price_cents: 45000,
      price_currency: "USD"
    )
    assert_equal "padi-rescue-diver", course.slug
  end

  test "to_param returns slug" do
    customer = customers(:jane_diver)
    assert_equal customer.slug, customer.to_param
  end

  test "resolves collisions by appending counter" do
    org = organizations(:reef_divers)
    first = org.customers.create!(first_name: "Collision", last_name: "Test")
    second = org.customers.create!(first_name: "Collision", last_name: "Test")
    third = org.customers.create!(first_name: "Collision", last_name: "Test")

    assert_equal "collision-test", first.slug
    assert_equal "collision-test-2", second.slug
    assert_equal "collision-test-3", third.slug
  end

  test "allows same slug in different scopes" do
    reef = organizations(:reef_divers)
    blue = organizations(:blue_water)

    reef_customer = reef.customers.create!(first_name: "Same", last_name: "Name")
    blue_customer = blue.customers.create!(first_name: "Same", last_name: "Name")

    assert_equal "same-name", reef_customer.slug
    assert_equal "same-name", blue_customer.slug
  end

  test "regenerates slug when source changes" do
    customer = organizations(:reef_divers).customers.create!(
      first_name: "Original",
      last_name: "Name"
    )
    assert_equal "original-name", customer.slug

    customer.update!(first_name: "Updated")
    assert_equal "updated-name", customer.slug
  end

  test "regenerates slug for symbol source when watched attr changes" do
    course = organizations(:reef_divers).courses.create!(
      name: "Old Name",
      agency: "PADI",
      level: "Open Water",
      course_type: :certification,
      max_students: 8,
      price_cents: 30000,
      price_currency: "USD"
    )
    assert_equal "old-name", course.slug

    course.update!(name: "New Name")
    assert_equal "new-name", course.slug
  end

  test "truncates slug to 80 characters" do
    long_name = "A" * 100
    customer = organizations(:reef_divers).customers.create!(
      first_name: long_name,
      last_name: "Lastname"
    )
    assert customer.slug.length <= 80
  end

  test "parameterizes non-ASCII characters" do
    customer = organizations(:reef_divers).customers.create!(
      first_name: "José",
      last_name: "García"
    )
    assert_equal "jose-garcia", customer.slug
  end

  test "falls back to record for blank source" do
    customer = organizations(:reef_divers).customers.new(
      first_name: "",
      last_name: ""
    )
    customer.valid? # triggers slug generation
    assert_equal "record", customer.slug
  end

  test "does not overwrite manually set slug on create" do
    customer = organizations(:reef_divers).customers.new(
      first_name: "Manual",
      last_name: "Slug",
      slug: "custom-slug"
    )
    customer.save!
    assert_equal "custom-slug", customer.slug
  end

  test "validates slug uniqueness within scope" do
    org = organizations(:reef_divers)
    first = org.customers.create!(first_name: "Unique", last_name: "Test")

    second = org.customers.new(first_name: "Different", last_name: "Person", slug: first.slug)
    assert_not second.valid?
    assert_includes second.errors[:slug], "has already been taken"
  end

  test "validates slug presence" do
    customer = organizations(:reef_divers).customers.new(
      first_name: "No",
      last_name: "Slug",
      slug: ""
    )
    # Force blank slug to bypass generation
    customer.instance_variable_set(:@skip_slug_generation, true)
    def customer.generate_slug; end
    customer.valid?
    assert_includes customer.errors[:slug], "can't be blank"
  end
end
