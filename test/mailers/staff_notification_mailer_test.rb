# frozen_string_literal: true

require "test_helper"

class StaffNotificationMailerTest < ActionMailer::TestCase
  setup do
    @organization = organizations(:reef_divers)
    @offering = course_offerings(:padi_ow_upcoming)
    @minor = customers(:minor_diver)
    @excursion = excursions(:morning_reef)
  end

  test "new_enrollment_request sends to managers and owners" do
    enrollment = @offering.enrollments.create!(
      customer: @minor,
      status: :requested,
      requested_at: Time.current,
      slug: "minor-mailer-test"
    )

    email = StaffNotificationMailer.new_enrollment_request(enrollment)
    assert_includes email.to, users(:owner_maria).email_address
    assert_includes email.to, users(:manager_carlos).email_address
    refute_includes email.to, users(:staff_ana).email_address
  end

  test "new_enrollment_request includes customer and course in subject" do
    enrollment = @offering.enrollments.create!(
      customer: @minor,
      status: :requested,
      requested_at: Time.current,
      slug: "minor-mailer-test-2"
    )

    email = StaffNotificationMailer.new_enrollment_request(enrollment)
    assert_includes email.subject, @minor.full_name
    assert_includes email.subject, @offering.course.name
  end

  test "new_join_request sends to managers and owners" do
    participant = @excursion.trip_participants.create!(
      customer: @minor,
      name: @minor.full_name,
      role: :diver,
      status: :tp_requested,
      requested_at: Time.current,
      slug: "minor-join-mailer-test"
    )

    email = StaffNotificationMailer.new_join_request(participant)
    assert_includes email.to, users(:owner_maria).email_address
    assert_includes email.to, users(:manager_carlos).email_address
  end

  test "new_join_request includes customer and excursion in subject" do
    participant = @excursion.trip_participants.create!(
      customer: @minor,
      name: @minor.full_name,
      role: :diver,
      status: :tp_requested,
      requested_at: Time.current,
      slug: "minor-join-mailer-test-2"
    )

    email = StaffNotificationMailer.new_join_request(participant)
    assert_includes email.subject, @minor.full_name
    assert_includes email.subject, @excursion.title
  end
end
