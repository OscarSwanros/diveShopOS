# frozen_string_literal: true

module Api
  module V1
    class ChecklistItemsController < BaseController
      before_action :set_template
      before_action :set_item, only: [ :show, :update, :destroy ]

      def index
        @checklist_items = @checklist_template.checklist_items.order(:position)
      end

      def show
      end

      def create
        @checklist_item = @checklist_template.checklist_items.build(item_params)
        authorize @checklist_template, :update?

        if @checklist_item.save
          render :show, status: :created
        else
          render_validation_errors(@checklist_item)
        end
      end

      def update
        authorize @checklist_template, :update?

        if @checklist_item.update(item_params)
          render :show
        else
          render_validation_errors(@checklist_item)
        end
      end

      def destroy
        authorize @checklist_template, :update?
        @checklist_item.destroy
        head :no_content
      end

      private

      def set_template
        @checklist_template = find_by_slug_or_id(current_organization.checklist_templates, params[:checklist_template_id])
        authorize @checklist_template, :show?
      end

      def set_item
        @checklist_item = find_by_slug_or_id(@checklist_template.checklist_items, params[:id])
      end

      def item_params
        params.require(:checklist_item).permit(:title, :description, :position, :required)
      end
    end
  end
end
