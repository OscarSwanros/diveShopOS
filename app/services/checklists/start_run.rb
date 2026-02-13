# frozen_string_literal: true

module Checklists
  class StartRun
    Result = Data.define(:success, :reason, :checklist_run)

    def initialize(template:, started_by:, checkable: nil)
      @template = template
      @started_by = started_by
      @checkable = checkable
    end

    def call
      unless @template.active?
        return Result.new(
          success: false,
          reason: I18n.t("services.checklists.start_run.template_inactive"),
          checklist_run: nil
        )
      end

      items = @template.items_ordered
      if items.empty?
        return Result.new(
          success: false,
          reason: I18n.t("services.checklists.start_run.no_items"),
          checklist_run: nil
        )
      end

      snapshot = build_snapshot(items)

      run = @template.checklist_runs.build(
        organization: @template.organization,
        started_by: @started_by,
        checkable: @checkable,
        status: :in_progress,
        template_snapshot: snapshot
      )

      if run.save
        items.each do |item|
          run.checklist_responses.create!(checklist_item: item)
        end

        Result.new(success: true, reason: nil, checklist_run: run)
      else
        Result.new(
          success: false,
          reason: run.errors.full_messages.join(", "),
          checklist_run: nil
        )
      end
    end

    private

    def build_snapshot(items)
      {
        template: {
          id: @template.id,
          title: @template.title,
          description: @template.description,
          category: @template.category
        },
        items: items.map { |item|
          {
            id: item.id,
            title: item.title,
            description: item.description,
            position: item.position,
            required: item.required
          }
        }
      }
    end
  end
end
