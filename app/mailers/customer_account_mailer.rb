# frozen_string_literal: true

class CustomerAccountMailer < ApplicationMailer
  def email_confirmation(customer_account)
    @customer_account = customer_account
    @customer = customer_account.customer
    @organization = customer_account.organization

    mail(
      to: customer_account.email,
      subject: I18n.t("customer_account_mailer.email_confirmation.subject", organization: @organization.name)
    )
  end

  def password_reset(customer_account, reset_token)
    @customer_account = customer_account
    @customer = customer_account.customer
    @organization = customer_account.organization
    @reset_token = reset_token

    mail(
      to: customer_account.email,
      subject: I18n.t("customer_account_mailer.password_reset.subject", organization: @organization.name)
    )
  end

  def enrollment_request_submitted(enrollment)
    @enrollment = enrollment
    @customer = enrollment.customer
    @customer_account = @customer.customer_account
    @course = enrollment.course_offering.course
    @organization = enrollment.course_offering.organization

    mail(
      to: @customer_account.email,
      subject: I18n.t("customer_account_mailer.enrollment_request_submitted.subject", course: @course.name)
    )
  end

  def enrollment_approved(enrollment)
    @enrollment = enrollment
    @customer = enrollment.customer
    @customer_account = @customer.customer_account
    @course = enrollment.course_offering.course
    @organization = enrollment.course_offering.organization

    mail(
      to: @customer_account.email,
      subject: I18n.t("customer_account_mailer.enrollment_approved.subject", course: @course.name)
    )
  end

  def enrollment_declined(enrollment)
    @enrollment = enrollment
    @customer = enrollment.customer
    @customer_account = @customer.customer_account
    @course = enrollment.course_offering.course
    @organization = enrollment.course_offering.organization

    mail(
      to: @customer_account.email,
      subject: I18n.t("customer_account_mailer.enrollment_declined.subject", course: @course.name)
    )
  end

  def join_request_submitted(trip_participant)
    @trip_participant = trip_participant
    @customer = trip_participant.customer
    @customer_account = @customer.customer_account
    @excursion = trip_participant.excursion
    @organization = @excursion.organization

    mail(
      to: @customer_account.email,
      subject: I18n.t("customer_account_mailer.join_request_submitted.subject", excursion: @excursion.title)
    )
  end

  def join_request_approved(trip_participant)
    @trip_participant = trip_participant
    @customer = trip_participant.customer
    @customer_account = @customer.customer_account
    @excursion = trip_participant.excursion
    @organization = @excursion.organization

    mail(
      to: @customer_account.email,
      subject: I18n.t("customer_account_mailer.join_request_approved.subject", excursion: @excursion.title)
    )
  end

  def join_request_declined(trip_participant)
    @trip_participant = trip_participant
    @customer = trip_participant.customer
    @customer_account = @customer.customer_account
    @excursion = trip_participant.excursion
    @organization = @excursion.organization

    mail(
      to: @customer_account.email,
      subject: I18n.t("customer_account_mailer.join_request_declined.subject", excursion: @excursion.title)
    )
  end

  def waitlist_joined(waitlist_entry)
    @waitlist_entry = waitlist_entry
    @customer = waitlist_entry.customer
    @customer_account = @customer.customer_account
    @organization = waitlist_entry.organization

    mail(
      to: @customer_account.email,
      subject: I18n.t("customer_account_mailer.waitlist_joined.subject", item: waitlist_entry.waitlistable.respond_to?(:title) ? waitlist_entry.waitlistable.title : waitlist_entry.waitlistable.to_s)
    )
  end

  def waitlist_spot_available(waitlist_entry)
    @waitlist_entry = waitlist_entry
    @customer = waitlist_entry.customer
    @customer_account = @customer.customer_account
    @organization = waitlist_entry.organization

    mail(
      to: @customer_account.email,
      subject: I18n.t("customer_account_mailer.waitlist_spot_available.subject", item: waitlist_entry.waitlistable.respond_to?(:title) ? waitlist_entry.waitlistable.title : waitlist_entry.waitlistable.to_s)
    )
  end
end
