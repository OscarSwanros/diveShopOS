# frozen_string_literal: true

module Checklists
  class AbandonRun
    Result = Data.define(:success, :reason)

    def initialize(run:, notes: nil)
      @run = run
      @notes = notes
    end

    def call
      unless @run.in_progress?
        return Result.new(
          success: false,
          reason: I18n.t("services.checklists.abandon_run.not_in_progress")
        )
      end

      if @notes.blank?
        return Result.new(
          success: false,
          reason: I18n.t("services.checklists.abandon_run.notes_required")
        )
      end

      @run.update!(status: :abandoned, notes: @notes)
      Result.new(success: true, reason: nil)
    end
  end
end
