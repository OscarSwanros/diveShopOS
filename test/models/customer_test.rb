# frozen_string_literal: true

require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  test "valid customer" do
    customer = customers(:jane_diver)
    assert customer.valid?
  end

  test "requires first_name" do
    customer = Customer.new(
      organization: organizations(:reef_divers),
      last_name: "Test"
    )
    assert_not customer.valid?
    assert_includes customer.errors[:first_name], "can't be blank"
  end

  test "requires last_name" do
    customer = Customer.new(
      organization: organizations(:reef_divers),
      first_name: "Test"
    )
    assert_not customer.valid?
    assert_includes customer.errors[:last_name], "can't be blank"
  end

  test "email uniqueness scoped to organization" do
    customer = Customer.new(
      organization: organizations(:reef_divers),
      first_name: "Duplicate",
      last_name: "Email",
      email: customers(:jane_diver).email
    )
    assert_not customer.valid?
    assert_includes customer.errors[:email], "has already been taken"
  end

  test "allows same email in different organizations" do
    customer = Customer.new(
      organization: organizations(:blue_water),
      first_name: "Same",
      last_name: "Email",
      email: customers(:jane_diver).email
    )
    assert customer.valid?
  end

  test "allows nil email" do
    customer = Customer.new(
      organization: organizations(:reef_divers),
      first_name: "No",
      last_name: "Email"
    )
    assert customer.valid?
  end

  test "normalizes email" do
    customer = customers(:jane_diver)
    customer.email = " JANE@EXAMPLE.COM "
    customer.save!
    assert_equal "jane@example.com", customer.email
  end

  test "full_name" do
    customer = customers(:jane_diver)
    assert_equal "Jane Diver", customer.full_name
  end

  test "age calculation" do
    customer = customers(:jane_diver)
    expected_age = Date.current.year - 1990
    expected_age -= 1 if Date.current < Date.new(Date.current.year, 5, 15)
    assert_equal expected_age, customer.age
  end

  test "age returns nil without date_of_birth" do
    customer = customers(:inactive_customer)
    assert_nil customer.age
  end

  test "age with custom as_of date" do
    customer = customers(:minor_diver)
    assert_equal 14, customer.age(as_of: Date.current)
  end

  test "active scope" do
    active = organizations(:reef_divers).customers.active
    assert_includes active, customers(:jane_diver)
    assert_not_includes active, customers(:inactive_customer)
  end

  test "by_name scope orders by last_name then first_name" do
    customers = organizations(:reef_divers).customers.by_name
    names = customers.map(&:last_name)
    assert_equal names.sort, names
  end

  test "current_medical_clearance returns latest valid clearance" do
    customer = customers(:jane_diver)
    clearance = customer.current_medical_clearance
    assert_equal medical_records(:jane_cleared), clearance
  end

  test "has many certifications" do
    customer = customers(:jane_diver)
    assert customer.certifications.count >= 2
  end

  test "has many medical records" do
    customer = customers(:jane_diver)
    assert customer.medical_records.count >= 1
  end

  test "generates UUID primary key" do
    customer = organizations(:reef_divers).customers.create!(
      first_name: "New",
      last_name: "Customer"
    )
    assert_match(/\A[0-9a-f-]{36}\z/, customer.id)
  end
end
