# frozen_string_literal: true

module Api
  module V1
    class ChecklistRunsController < BaseController
      include ApiPagination

      before_action :set_run, only: [ :show, :destroy, :complete, :abandon ]

      def index
        scope = policy_scope(current_organization.checklist_runs)
          .includes(:checklist_template, :started_by)
        scope = scope.where(status: params[:status]) if params[:status].present?
        @checklist_runs = paginate(scope.order(created_at: :desc))
      end

      def show
      end

      def create
        template = find_by_slug_or_id(current_organization.checklist_templates, params[:checklist_template_id])
        checkable = resolve_checkable

        result = Checklists::StartRun.new(
          template: template,
          started_by: current_user,
          checkable: checkable
        ).call

        if result.success
          @checklist_run = result.checklist_run
          render :show, status: :created
        else
          render json: {
            error: { code: "validation_failed", message: result.reason }
          }, status: :unprocessable_entity
        end
      end

      def complete
        result = Checklists::CompleteRun.new(
          run: @checklist_run,
          notes: params[:notes]
        ).call

        if result.success
          render :show
        else
          render json: {
            error: { code: "validation_failed", message: result.reason }
          }, status: :unprocessable_entity
        end
      end

      def abandon
        result = Checklists::AbandonRun.new(
          run: @checklist_run,
          notes: params[:notes]
        ).call

        if result.success
          render :show
        else
          render json: {
            error: { code: "validation_failed", message: result.reason }
          }, status: :unprocessable_entity
        end
      end

      def destroy
        @checklist_run.destroy
        head :no_content
      end

      private

      def set_run
        @checklist_run = find_by_slug_or_id(current_organization.checklist_runs, params[:id])
        authorize @checklist_run
      end

      def resolve_checkable
        return nil unless params[:checkable_type].present? && params[:checkable_id].present?

        case params[:checkable_type]
        when "Excursion"
          current_organization.excursions.find(params[:checkable_id])
        when "EquipmentItem"
          current_organization.equipment_items.find(params[:checkable_id])
        end
      end
    end
  end
end
