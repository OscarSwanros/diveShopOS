# frozen_string_literal: true

require "test_helper"

class EnrollmentMailerTest < ActionMailer::TestCase
  test "confirmation sends email to customer" do
    enrollment = enrollments(:jane_in_ow)
    email = EnrollmentMailer.confirmation(enrollment)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "jane@example.com" ], email.to
    assert_includes email.subject, "PADI Open Water Diver"
  end

  test "confirmation includes course details" do
    enrollment = enrollments(:jane_in_ow)
    email = EnrollmentMailer.confirmation(enrollment)

    assert_includes email.body.encoded, "PADI Open Water Diver"
    assert_includes email.body.encoded, enrollment.course_offering.instructor.name
  end

  test "confirmation skips when customer has no email" do
    enrollment = enrollments(:jane_in_ow)
    enrollment.customer.update!(email: nil)

    email = EnrollmentMailer.confirmation(enrollment)

    assert_nil email.message.to
  end

  test "completion sends email to customer" do
    enrollment = enrollments(:jane_in_ow)
    email = EnrollmentMailer.completion(enrollment)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "jane@example.com" ], email.to
    assert_includes email.subject, "PADI Open Water Diver"
  end

  test "completion includes certification when present" do
    enrollment = enrollments(:jane_in_ow)
    cert = enrollment.customer.certifications.create!(
      agency: "PADI",
      certification_level: "Open Water",
      issued_date: Date.current
    )
    enrollment.update!(certification: cert)

    email = EnrollmentMailer.completion(enrollment)

    assert_includes email.body.encoded, "PADI"
    assert_includes email.body.encoded, "Open Water"
  end

  test "completion skips when customer has no email" do
    enrollment = enrollments(:jane_in_ow)
    enrollment.customer.update!(email: nil)

    email = EnrollmentMailer.completion(enrollment)

    assert_nil email.message.to
  end
end
