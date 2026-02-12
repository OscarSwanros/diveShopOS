# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @organization = Organization.create!(name: "Test Dive Shop", slug: "test-dive-shop")
  end

  test "valid user" do
    user = User.new(
      organization: @organization,
      email_address: "diver@example.com",
      password: "password123",
      name: "Jane Diver"
    )
    assert user.valid?
  end

  test "requires email_address" do
    user = User.new(organization: @organization, password: "password123", name: "Jane")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "requires name" do
    user = User.new(organization: @organization, email_address: "test@example.com", password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "requires valid email format" do
    user = User.new(organization: @organization, email_address: "not-an-email", password: "password123", name: "Jane")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "is invalid"
  end

  test "email must be unique within organization" do
    User.create!(organization: @organization, email_address: "diver@example.com", password: "password123", name: "User One")
    user = User.new(organization: @organization, email_address: "diver@example.com", password: "password123", name: "User Two")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "same email allowed in different organizations" do
    other_org = Organization.create!(name: "Other Shop", slug: "other-shop")
    User.create!(organization: @organization, email_address: "diver@example.com", password: "password123", name: "User One")
    user = User.new(organization: other_org, email_address: "diver@example.com", password: "password123", name: "User Two")
    assert user.valid?
  end

  test "normalizes email_address to lowercase" do
    user = User.new(organization: @organization, email_address: "  DIVER@Example.COM  ", password: "password123", name: "Jane")
    assert_equal "diver@example.com", user.email_address
  end

  test "default role is staff" do
    user = User.new(organization: @organization, email_address: "test@example.com", password: "password123", name: "Jane")
    assert user.staff?
  end

  test "role can be set to manager or owner" do
    user = User.create!(organization: @organization, email_address: "manager@example.com", password: "password123", name: "Manager", role: :manager)
    assert user.manager?

    user.update!(role: :owner)
    assert user.owner?
  end

  test "generates UUID primary key" do
    user = User.create!(organization: @organization, email_address: "test@example.com", password: "password123", name: "Jane")
    assert_match(/\A[0-9a-f-]{36}\z/, user.id)
  end

  test "authenticates with correct password" do
    user = User.create!(organization: @organization, email_address: "test@example.com", password: "password123", name: "Jane")
    assert user.authenticate("password123")
    assert_not user.authenticate("wrong")
  end
end
