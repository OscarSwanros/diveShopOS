# frozen_string_literal: true

module Checklists
  class CompleteRun
    Result = Data.define(:success, :reason)

    def initialize(run:, notes: nil)
      @run = run
      @notes = notes
    end

    def call
      unless @run.in_progress?
        return Result.new(
          success: false,
          reason: I18n.t("services.checklists.complete_run.not_in_progress")
        )
      end

      if @run.all_required_checked?
        @run.update!(status: :completed, completed_at: Time.current, notes: @notes)
      else
        if @notes.blank?
          return Result.new(
            success: false,
            reason: I18n.t("services.checklists.complete_run.notes_required")
          )
        end

        @run.update!(status: :completed_with_exceptions, completed_at: Time.current, notes: @notes)
      end

      Result.new(success: true, reason: nil)
    end
  end
end
