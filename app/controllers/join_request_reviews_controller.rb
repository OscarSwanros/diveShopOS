# frozen_string_literal: true

class JoinRequestReviewsController < ApplicationController
  before_action :set_trip_participant

  def approve
    authorize @trip_participant, :review?

    @trip_participant.update!(status: :tp_confirmed)

    CustomerAccountMailer.join_request_approved(@trip_participant).deliver_later
    redirect_to review_queue_path, notice: I18n.t("review_queue.approved")
  end

  def decline
    authorize @trip_participant, :review?

    @trip_participant.decline!(reason: params[:reason])

    CustomerAccountMailer.join_request_declined(@trip_participant).deliver_later
    redirect_to review_queue_path, notice: I18n.t("review_queue.declined")
  end

  private

  def set_trip_participant
    @trip_participant = TripParticipant
      .joins(:excursion)
      .where(excursions: { organization_id: current_organization.id })
      .find_by!(slug: params[:id])
  end
end
