# frozen_string_literal: true

module Public
  class RequestExcursionJoin
    Result = Data.define(:success, :trip_participant, :error)

    def initialize(customer:, excursion:)
      @customer = customer
      @excursion = excursion
    end

    def call
      # Check for duplicate
      existing = @excursion.trip_participants
        .where(customer: @customer)
        .where.not(status: :tp_cancelled)
        .exists?

      if existing
        return Result.new(
          success: false,
          trip_participant: nil,
          error: I18n.t("public.join_requests.duplicate")
        )
      end

      # Check capacity
      gate_results = {}
      capacity_result = Excursions::CheckCapacity.new(excursion: @excursion).call
      gate_results["capacity"] = { passed: capacity_result.success, reason: capacity_result.reason }

      participant = @excursion.trip_participants.build(
        customer: @customer,
        name: @customer.full_name,
        email: @customer.email,
        role: :diver,
        status: :tp_requested,
        requested_at: Time.current,
        safety_gate_results: gate_results
      )

      if participant.save
        Result.new(success: true, trip_participant: participant, error: nil)
      else
        Result.new(success: false, trip_participant: participant, error: participant.errors.full_messages.join(", "))
      end
    end
  end
end
