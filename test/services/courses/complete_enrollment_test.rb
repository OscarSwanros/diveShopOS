# frozen_string_literal: true

require "test_helper"

class Courses::CompleteEnrollmentTest < ActiveSupport::TestCase
  test "completes enrollment with full attendance for certification course" do
    enrollment = enrollments(:jane_in_ow)
    # Jane has attended all 4 sessions via fixtures

    result = Courses::CompleteEnrollment.new(
      enrollment: enrollment,
      organization: organizations(:reef_divers)
    ).call

    assert result.success
    assert_nil result.reason

    enrollment.reload
    assert enrollment.completed?
    assert_not_nil enrollment.completed_at
    assert_not_nil enrollment.certification

    cert = result.certification
    assert_equal "PADI", cert.agency
    assert_equal "Open Water", cert.certification_level
    assert_equal Date.current, cert.issued_date
    assert_equal organizations(:reef_divers), cert.issuing_organization
  end

  test "fails when sessions are not all attended" do
    enrollment = enrollments(:bob_in_ow)
    # Bob only attended classroom_1 (true), confined_1 (false), and is missing ow1/ow2

    result = Courses::CompleteEnrollment.new(
      enrollment: enrollment,
      organization: organizations(:reef_divers)
    ).call

    assert_not result.success
    assert_includes result.reason, "session"
    assert_nil result.certification

    enrollment.reload
    assert_not enrollment.completed?
  end

  test "completes non-certification course without creating certification" do
    # Use SSI Nitrox (specialty, not certification type)
    course = courses(:ssi_nitrox)
    offering = CourseOffering.create!(
      course: course,
      organization: organizations(:reef_divers),
      instructor: users(:manager_carlos),
      start_date: Date.current + 30.days,
      max_students: 6
    )
    enrollment = Enrollment.create!(
      course_offering: offering,
      customer: customers(:jane_diver),
      status: :confirmed,
      enrolled_at: Time.current
    )
    # No sessions means ValidateCompletion passes (no sessions to attend)

    result = Courses::CompleteEnrollment.new(
      enrollment: enrollment,
      organization: organizations(:reef_divers)
    ).call

    assert result.success
    assert_nil result.certification

    enrollment.reload
    assert enrollment.completed?
    assert_nil enrollment.certification_id
  end

  test "creates certification record on customer" do
    enrollment = enrollments(:jane_in_ow)
    customer = enrollment.customer
    initial_cert_count = customer.certifications.count

    Courses::CompleteEnrollment.new(
      enrollment: enrollment,
      organization: organizations(:reef_divers)
    ).call

    assert_equal initial_cert_count + 1, customer.certifications.count
  end
end
