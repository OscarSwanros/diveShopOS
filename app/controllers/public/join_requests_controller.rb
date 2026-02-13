# frozen_string_literal: true

module Public
  class JoinRequestsController < Public::BaseController
    before_action :require_customer_authentication
    before_action :set_excursion

    def new
    end

    def create
      result = Public::RequestExcursionJoin.new(
        customer: current_customer_account.customer,
        excursion: @excursion
      ).call

      if result.success
        CustomerAccountMailer.join_request_submitted(result.trip_participant).deliver_later
        StaffNotificationMailer.new_join_request(result.trip_participant).deliver_later
        redirect_to catalog_excursion_path(@excursion),
          notice: I18n.t("public.join_requests.created")
      else
        flash.now[:alert] = result.error
        render :new, status: :unprocessable_entity
      end
    end

    private

    def set_excursion
      @excursion = current_organization.excursions.published.find_by!(slug: params[:excursion_slug])
    end
  end
end
