# frozen_string_literal: true

class ChecklistResponsesController < ApplicationController
  before_action :set_run
  before_action :set_response

  def update
    authorize @response

    result = Checklists::CompleteItem.new(
      response: @response,
      completed_by: current_user,
      checked: params[:checklist_response][:checked] == "1",
      notes: params[:checklist_response][:notes]
    ).call

    if result.success
      redirect_to checklist_run_path(@run)
    else
      redirect_to checklist_run_path(@run), alert: result.reason
    end
  end

  private

  def set_run
    @run = current_organization.checklist_runs.find_by!(slug: params[:checklist_run_id])
  end

  def set_response
    @response = @run.checklist_responses.find(params[:id])
  end
end
