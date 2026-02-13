# frozen_string_literal: true

class StaffNotificationMailer < ApplicationMailer
  def new_enrollment_request(enrollment)
    @enrollment = enrollment
    @customer = enrollment.customer
    @course = enrollment.course_offering.course
    @organization = enrollment.course_offering.organization
    @recipients = staff_recipients(@organization)

    mail(
      to: @recipients,
      subject: I18n.t("staff_notification_mailer.new_enrollment_request.subject",
        customer: @customer.full_name, course: @course.name)
    )
  end

  def new_join_request(trip_participant)
    @trip_participant = trip_participant
    @customer = trip_participant.customer
    @excursion = trip_participant.excursion
    @organization = @excursion.organization
    @recipients = staff_recipients(@organization)

    mail(
      to: @recipients,
      subject: I18n.t("staff_notification_mailer.new_join_request.subject",
        customer: @customer.full_name, excursion: @excursion.title)
    )
  end

  def enrollment_cancelled(enrollment)
    @enrollment = enrollment
    @customer = enrollment.customer
    @course = enrollment.course_offering.course
    @organization = enrollment.course_offering.organization
    @recipients = staff_recipients(@organization)

    mail(
      to: @recipients,
      subject: I18n.t("staff_notification_mailer.enrollment_cancelled.subject",
        customer: @customer.full_name, course: @course.name)
    )
  end

  def join_cancelled(trip_participant)
    @trip_participant = trip_participant
    @customer = trip_participant.customer
    @excursion = trip_participant.excursion
    @organization = @excursion.organization
    @recipients = staff_recipients(@organization)

    mail(
      to: @recipients,
      subject: I18n.t("staff_notification_mailer.join_cancelled.subject",
        customer: @customer.full_name, excursion: @excursion.title)
    )
  end

  private

  def staff_recipients(organization)
    organization.users.where(role: [ :manager, :owner ]).pluck(:email_address)
  end
end
