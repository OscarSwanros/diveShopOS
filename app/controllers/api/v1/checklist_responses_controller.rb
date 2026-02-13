# frozen_string_literal: true

module Api
  module V1
    class ChecklistResponsesController < BaseController
      before_action :set_run
      before_action :set_response, only: [ :show, :update ]

      def index
        @checklist_responses = @checklist_run.checklist_responses
          .includes(:checklist_item, :completed_by)
          .joins(:checklist_item)
          .order("checklist_items.position ASC")
      end

      def show
      end

      def update
        authorize @checklist_response

        result = Checklists::CompleteItem.new(
          response: @checklist_response,
          completed_by: current_user,
          checked: params[:checked] == true || params[:checked] == "true",
          notes: params[:notes]
        ).call

        if result.success
          @checklist_response.reload
          render :show
        else
          render json: {
            error: { code: "validation_failed", message: result.reason }
          }, status: :unprocessable_entity
        end
      end

      private

      def set_run
        @checklist_run = find_by_slug_or_id(current_organization.checklist_runs, params[:checklist_run_id])
        authorize @checklist_run, :show?
      end

      def set_response
        @checklist_response = @checklist_run.checklist_responses.find(params[:id])
      end
    end
  end
end
