# frozen_string_literal: true

require "test_helper"

class CourseTest < ActiveSupport::TestCase
  test "valid course" do
    course = courses(:padi_ow)
    assert course.valid?
  end

  test "requires name" do
    course = Course.new(
      organization: organizations(:reef_divers),
      agency: "PADI",
      level: "Open Water"
    )
    assert_not course.valid?
    assert_includes course.errors[:name], "can't be blank"
  end

  test "requires agency" do
    course = Course.new(
      organization: organizations(:reef_divers),
      name: "Test Course",
      level: "Open Water"
    )
    assert_not course.valid?
    assert_includes course.errors[:agency], "can't be blank"
  end

  test "requires level" do
    course = Course.new(
      organization: organizations(:reef_divers),
      name: "Test Course",
      agency: "PADI"
    )
    assert_not course.valid?
    assert_includes course.errors[:level], "can't be blank"
  end

  test "name uniqueness scoped to organization" do
    course = Course.new(
      organization: organizations(:reef_divers),
      name: courses(:padi_ow).name,
      agency: "PADI",
      level: "Test"
    )
    assert_not course.valid?
    assert_includes course.errors[:name], "has already been taken"
  end

  test "allows same name in different organizations" do
    course = Course.new(
      organization: organizations(:blue_water),
      name: courses(:padi_ow).name,
      agency: "PADI",
      level: "Open Water"
    )
    assert course.valid?
  end

  test "max_students must be positive" do
    course = courses(:padi_ow)
    course.max_students = 0
    assert_not course.valid?
  end

  test "price_cents must be non-negative" do
    course = courses(:padi_ow)
    course.price_cents = -100
    assert_not course.valid?
  end

  test "course_type enum" do
    assert courses(:padi_ow).certification?
    assert courses(:ssi_nitrox).specialty?
    assert courses(:inactive_course).non_certification?
  end

  test "active scope" do
    active = organizations(:reef_divers).courses.active
    assert_includes active, courses(:padi_ow)
    assert_not_includes active, courses(:inactive_course)
  end

  test "by_agency scope" do
    padi = organizations(:reef_divers).courses.by_agency("PADI")
    assert_includes padi, courses(:padi_ow)
    assert_not_includes padi, courses(:ssi_nitrox)
  end

  test "by_type scope" do
    certification = organizations(:reef_divers).courses.by_type(:certification)
    assert_includes certification, courses(:padi_ow)
    assert_not_includes certification, courses(:ssi_nitrox)
  end

  test "generates UUID primary key" do
    course = organizations(:reef_divers).courses.create!(
      name: "New Course",
      agency: "PADI",
      level: "Test"
    )
    assert_match(/\A[0-9a-f-]{36}\z/, course.id)
  end
end
