# frozen_string_literal: true

class ExcursionChecklistRunsController < ApplicationController
  before_action :set_excursion

  def new
    authorize ChecklistRun
    @templates = current_organization.checklist_templates.active.by_category(:safety).order(:title)
  end

  def create
    authorize ChecklistRun

    template = current_organization.checklist_templates.find_by!(slug: params[:checklist_template_id])

    result = Checklists::StartRun.new(
      template: template,
      started_by: current_user,
      checkable: @excursion
    ).call

    if result.success
      redirect_to checklist_run_path(result.checklist_run), notice: I18n.t("checklist_runs.created")
    else
      redirect_to excursion_path(@excursion), alert: result.reason
    end
  end

  private

  def set_excursion
    @excursion = current_organization.excursions.find_by!(slug: params[:excursion_id])
  end
end
