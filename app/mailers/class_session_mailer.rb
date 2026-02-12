# frozen_string_literal: true

class ClassSessionMailer < ApplicationMailer
  def reschedule_notification(class_session, enrollment)
    @class_session = class_session
    @enrollment = enrollment
    @customer = enrollment.customer
    @course_offering = class_session.course_offering
    @course = @course_offering.course

    mail(
      to: @customer.email,
      subject: I18n.t("class_session_mailer.reschedule_notification.subject", course: @course.name)
    ) if @customer.email.present?
  end
end
