# frozen_string_literal: true

module Api
  module V1
    class EquipmentItemsController < BaseController
      include ApiPagination

      before_action :set_equipment_item, only: [ :show, :update, :destroy ]

      def index
        @equipment_items = policy_scope(current_organization.equipment_items)

        @equipment_items = @equipment_items.by_category(params[:category]) if params[:category].present?
        @equipment_items = @equipment_items.where(status: params[:status]) if params[:status].present?
        @equipment_items = @equipment_items.by_size(params[:size]) if params[:size].present?
        @equipment_items = paginate(@equipment_items.order(:category, :name))
      end

      def show
      end

      def create
        @equipment_item = current_organization.equipment_items.build(equipment_item_params)
        authorize @equipment_item

        if @equipment_item.save
          render :show, status: :created
        else
          render_validation_errors(@equipment_item)
        end
      end

      def update
        if @equipment_item.update(equipment_item_params)
          render :show
        else
          render_validation_errors(@equipment_item)
        end
      end

      def destroy
        @equipment_item.destroy
        head :no_content
      end

      private

      def set_equipment_item
        @equipment_item = find_by_slug_or_id(current_organization.equipment_items, params[:id])
        authorize @equipment_item
      end

      def equipment_item_params
        params.require(:equipment_item).permit(
          :category, :name, :serial_number, :size, :manufacturer, :product_model,
          :status, :life_support, :purchase_date, :notes
        )
      end
    end
  end
end
