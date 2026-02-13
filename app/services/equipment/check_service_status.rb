# frozen_string_literal: true

module Equipment
  class CheckServiceStatus
    Result = Data.define(:success, :reason)

    def initialize(equipment_item:)
      @equipment_item = equipment_item
    end

    def call
      return Result.new(success: true, reason: nil) unless @equipment_item.life_support?

      if @equipment_item.last_service_date.blank?
        Result.new(
          success: false,
          reason: I18n.t("services.equipment.check_service_status.no_service_record",
            item: @equipment_item.name)
        )
      elsif @equipment_item.service_overdue?
        Result.new(
          success: false,
          reason: I18n.t("services.equipment.check_service_status.service_overdue",
            item: @equipment_item.name,
            due_date: I18n.l(@equipment_item.next_service_due))
        )
      else
        Result.new(success: true, reason: nil)
      end
    end
  end
end
