# frozen_string_literal: true

module Public
  class DashboardController < Public::BaseController
    before_action :require_customer_authentication

    def show
      customer = current_customer_account.customer

      @enrollments = customer.enrollments
        .where.not(status: [ :withdrawn, :failed, :declined ])
        .includes(course_offering: :course)
        .order(created_at: :desc)

      @trip_participations = TripParticipant
        .where(customer: customer)
        .where.not(status: :tp_cancelled)
        .includes(:excursion)
        .order(created_at: :desc)

      @certifications = customer.certifications.kept.order(issued_date: :desc)
    end
  end
end
