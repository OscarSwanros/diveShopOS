# frozen_string_literal: true

module Public
  class CancellationsController < Public::BaseController
    before_action :require_customer_authentication

    def cancel_enrollment
      customer = current_customer_account.customer
      enrollment = customer.enrollments
        .where(status: [ :pending, :confirmed, :active, :requested ])
        .find_by!(slug: params[:id])

      enrollment.withdraw!
      StaffNotificationMailer.enrollment_cancelled(enrollment).deliver_later
      redirect_to my_dashboard_path, notice: I18n.t("public.cancellations.enrollment_cancelled")
    end

    def cancel_join
      customer = current_customer_account.customer
      participation = TripParticipant
        .where(customer: customer)
        .where(status: [ :tp_requested, :tp_confirmed ])
        .find_by!(slug: params[:id])

      participation.update!(status: :tp_cancelled)
      StaffNotificationMailer.join_cancelled(participation).deliver_later
      redirect_to my_dashboard_path, notice: I18n.t("public.cancellations.join_cancelled")
    end
  end
end
