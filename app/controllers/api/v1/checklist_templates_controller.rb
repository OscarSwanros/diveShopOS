# frozen_string_literal: true

module Api
  module V1
    class ChecklistTemplatesController < BaseController
      include ApiPagination

      before_action :set_template, only: [ :show, :update, :destroy ]

      def index
        scope = policy_scope(current_organization.checklist_templates)
        scope = scope.by_category(params[:category]) if params[:category].present?
        scope = scope.active if params[:active] == "true"
        @checklist_templates = paginate(scope.order(:category, :title))
      end

      def show
      end

      def create
        @checklist_template = current_organization.checklist_templates.build(template_params)
        authorize @checklist_template

        if @checklist_template.save
          render :show, status: :created
        else
          render_validation_errors(@checklist_template)
        end
      end

      def update
        if @checklist_template.update(template_params)
          render :show
        else
          render_validation_errors(@checklist_template)
        end
      end

      def destroy
        if @checklist_template.destroy
          head :no_content
        else
          render_validation_errors(@checklist_template)
        end
      end

      private

      def set_template
        @checklist_template = find_by_slug_or_id(current_organization.checklist_templates, params[:id])
        authorize @checklist_template
      end

      def template_params
        params.require(:checklist_template).permit(:title, :description, :category, :active)
      end
    end
  end
end
