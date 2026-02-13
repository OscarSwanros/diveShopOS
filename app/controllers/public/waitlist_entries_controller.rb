# frozen_string_literal: true

module Public
  class WaitlistEntriesController < Public::BaseController
    before_action :require_customer_authentication

    def create
      waitlistable = find_waitlistable
      result = Public::JoinWaitlist.new(
        customer: current_customer_account.customer,
        waitlistable: waitlistable
      ).call

      if result.success
        CustomerAccountMailer.waitlist_joined(result.waitlist_entry).deliver_later
        redirect_to catalog_path_for(waitlistable), notice: I18n.t("public.waitlist.joined")
      else
        redirect_to catalog_path_for(waitlistable), alert: result.error
      end
    end

    def destroy
      entry = current_customer_account.customer.waitlist_entries.waiting.find_by!(slug: params[:id])
      waitlistable = entry.waitlistable
      entry.cancel!
      redirect_to catalog_path_for(waitlistable), notice: I18n.t("public.waitlist.cancelled")
    end

    private

    def find_waitlistable
      if params[:waitlistable_type] == "CourseOffering"
        CourseOffering.find(params[:waitlistable_id])
      elsif params[:waitlistable_type] == "Excursion"
        current_organization.excursions.published.find(params[:waitlistable_id])
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def catalog_path_for(waitlistable)
      case waitlistable
      when Excursion
        catalog_excursion_path(waitlistable)
      when CourseOffering
        catalog_course_path(waitlistable.course)
      else
        catalog_excursions_path
      end
    end
  end
end
