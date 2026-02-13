# frozen_string_literal: true

class ReviewQueueController < ApplicationController
  def show
    authorize :review_queue, :show?

    @pending_enrollments = Enrollment
      .review_queue
      .joins(:course_offering)
      .where(course_offerings: { organization_id: current_organization.id })
      .includes(:customer, course_offering: :course)

    @pending_joins = TripParticipant
      .review_queue
      .joins(:excursion)
      .where(excursions: { organization_id: current_organization.id })
      .includes(:customer, :excursion)
  end
end
