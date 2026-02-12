# frozen_string_literal: true

module Excursions
  class CheckCapacity
    Result = Data.define(:success, :reason)

    def initialize(excursion:)
      @excursion = excursion
    end

    def call
      current_count = @excursion.trip_participants.count
      capacity = @excursion.capacity

      if current_count >= capacity
        Result.new(
          success: false,
          reason: I18n.t("services.excursions.check_capacity.at_capacity",
            capacity: capacity, count: current_count)
        )
      else
        Result.new(success: true, reason: nil)
      end
    end
  end
end
