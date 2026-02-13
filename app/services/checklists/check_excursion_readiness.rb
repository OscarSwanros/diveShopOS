# frozen_string_literal: true

module Checklists
  class CheckExcursionReadiness
    Result = Data.define(:success, :reason)

    def initialize(excursion:)
      @excursion = excursion
    end

    def call
      incomplete_runs = @excursion.checklist_runs
        .joins(:checklist_template)
        .where(checklist_templates: { category: :safety })
        .where(status: :in_progress)

      if incomplete_runs.any?
        titles = incomplete_runs.map { |r| r.checklist_template.title }.join(", ")
        Result.new(
          success: false,
          reason: I18n.t("services.checklists.check_excursion_readiness.incomplete",
            checklists: titles)
        )
      else
        Result.new(success: true, reason: nil)
      end
    end
  end
end
