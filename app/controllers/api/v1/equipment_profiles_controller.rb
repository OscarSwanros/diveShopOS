# frozen_string_literal: true

module Api
  module V1
    class EquipmentProfilesController < BaseController
      before_action :set_customer
      before_action :set_equipment_profile, only: [ :show, :update, :destroy ]

      def show
      end

      def create
        @equipment_profile = @customer.build_equipment_profile(equipment_profile_params)
        authorize @equipment_profile

        if @equipment_profile.save
          render :show, status: :created
        else
          render_validation_errors(@equipment_profile)
        end
      end

      def update
        if @equipment_profile.update(equipment_profile_params)
          render :show
        else
          render_validation_errors(@equipment_profile)
        end
      end

      def destroy
        @equipment_profile.destroy
        head :no_content
      end

      private

      def set_customer
        @customer = current_organization.customers.find(params[:customer_id])
      end

      def set_equipment_profile
        @equipment_profile = @customer.equipment_profile
        raise ActiveRecord::RecordNotFound unless @equipment_profile
        authorize @equipment_profile
      end

      def equipment_profile_params
        params.require(:equipment_profile).permit(
          :height_cm, :weight_kg, :wetsuit_size, :wetsuit_thickness_mm,
          :bcd_size, :boot_size, :fin_size, :glove_size,
          :owns_mask, :owns_computer, :owns_wetsuit, :owns_fins,
          :owns_bcd, :owns_regulator, :notes
        )
      end
    end
  end
end
