# frozen_string_literal: true

class ChecklistRunsController < ApplicationController
  before_action :set_run, only: [ :show, :complete, :abandon ]

  def index
    @runs = policy_scope(current_organization.checklist_runs)
      .includes(:checklist_template, :started_by)
      .order(created_at: :desc)
  end

  def show
    @responses = @run.checklist_responses
      .includes(:checklist_item, :completed_by)
      .joins(:checklist_item)
      .order("checklist_items.position ASC")
  end

  def complete
    result = Checklists::CompleteRun.new(
      run: @run,
      notes: params[:notes]
    ).call

    if result.success
      status = @run.reload.completed? ? I18n.t("checklist_runs.completed") : I18n.t("checklist_runs.completed_with_exceptions")
      redirect_to @run, notice: status
    else
      redirect_to @run, alert: result.reason
    end
  end

  def abandon
    result = Checklists::AbandonRun.new(
      run: @run,
      notes: params[:notes]
    ).call

    if result.success
      redirect_to @run, notice: I18n.t("checklist_runs.abandoned")
    else
      redirect_to @run, alert: result.reason
    end
  end

  private

  def set_run
    @run = current_organization.checklist_runs.find_by!(slug: params[:id])
    authorize @run
  end
end
