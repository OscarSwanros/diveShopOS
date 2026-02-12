# frozen_string_literal: true

require "test_helper"

class ClassSessionMailerTest < ActionMailer::TestCase
  test "reschedule_notification sends email to customer" do
    session = class_sessions(:ow_classroom_1)
    enrollment = enrollments(:jane_in_ow)
    email = ClassSessionMailer.reschedule_notification(session, enrollment)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "jane@example.com" ], email.to
    assert_includes email.subject, "PADI Open Water Diver"
  end

  test "reschedule_notification includes session details" do
    session = class_sessions(:ow_classroom_1)
    enrollment = enrollments(:jane_in_ow)
    email = ClassSessionMailer.reschedule_notification(session, enrollment)

    assert_includes email.body.encoded, "Module 1: Dive Theory"
  end

  test "reschedule_notification skips when customer has no email" do
    session = class_sessions(:ow_classroom_1)
    enrollment = enrollments(:jane_in_ow)
    enrollment.customer.update!(email: nil)

    email = ClassSessionMailer.reschedule_notification(session, enrollment)

    assert_nil email.message.to
  end
end
