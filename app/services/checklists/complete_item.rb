# frozen_string_literal: true

module Checklists
  class CompleteItem
    Result = Data.define(:success, :reason)

    def initialize(response:, completed_by:, checked:, notes: nil)
      @response = response
      @completed_by = completed_by
      @checked = checked
      @notes = notes
    end

    def call
      run = @response.checklist_run

      unless run.in_progress?
        return Result.new(
          success: false,
          reason: I18n.t("services.checklists.complete_item.run_not_in_progress")
        )
      end

      if @checked
        @response.update!(
          checked: true,
          checked_at: Time.current,
          completed_by: @completed_by,
          notes: @notes
        )
      else
        @response.update!(
          checked: false,
          checked_at: nil,
          completed_by: nil,
          notes: @notes
        )
      end

      if run.all_required_checked?
        run.update!(status: :completed, completed_at: Time.current)
      end

      Result.new(success: true, reason: nil)
    end
  end
end
