# frozen_string_literal: true

module Equipment
  class CheckTankCompliance
    Result = Data.define(:success, :reason)

    def initialize(customer_tank:)
      @customer_tank = customer_tank
    end

    def call
      unless @customer_tank.vip_current?
        return Result.new(
          success: false,
          reason: I18n.t("services.equipment.check_tank_compliance.vip_expired",
            serial: @customer_tank.serial_number)
        )
      end

      unless @customer_tank.hydro_current?
        return Result.new(
          success: false,
          reason: I18n.t("services.equipment.check_tank_compliance.hydro_expired",
            serial: @customer_tank.serial_number)
        )
      end

      Result.new(success: true, reason: nil)
    end
  end
end
