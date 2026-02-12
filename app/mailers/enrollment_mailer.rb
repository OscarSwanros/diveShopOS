# frozen_string_literal: true

class EnrollmentMailer < ApplicationMailer
  def confirmation(enrollment)
    @enrollment = enrollment
    @customer = enrollment.customer
    @course_offering = enrollment.course_offering
    @course = @course_offering.course
    @organization = @course_offering.organization

    mail(
      to: @customer.email,
      subject: I18n.t("enrollment_mailer.confirmation.subject", course: @course.name)
    ) if @customer.email.present?
  end

  def completion(enrollment)
    @enrollment = enrollment
    @customer = enrollment.customer
    @course_offering = enrollment.course_offering
    @course = @course_offering.course
    @organization = @course_offering.organization
    @certification = enrollment.certification

    mail(
      to: @customer.email,
      subject: I18n.t("enrollment_mailer.completion.subject", course: @course.name)
    ) if @customer.email.present?
  end
end
