# frozen_string_literal: true

class ChecklistTemplatesController < ApplicationController
  before_action :set_template, only: [ :show, :edit, :update, :destroy ]

  def index
    @templates = policy_scope(current_organization.checklist_templates)
      .includes(:checklist_items)
      .order(:category, :title)
  end

  def show
    @items = @template.items_ordered
    @runs = @template.checklist_runs.order(created_at: :desc).limit(10)
  end

  def new
    @template = current_organization.checklist_templates.build
    authorize @template
  end

  def create
    @template = current_organization.checklist_templates.build(template_params)
    authorize @template

    if @template.save
      redirect_to @template, notice: I18n.t("checklist_templates.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @template.update(template_params)
      redirect_to @template, notice: I18n.t("checklist_templates.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @template.destroy
      redirect_to checklist_templates_path, notice: I18n.t("checklist_templates.deleted")
    else
      redirect_to @template, alert: @template.errors.full_messages.join(", ")
    end
  end

  private

  def set_template
    @template = current_organization.checklist_templates.find_by!(slug: params[:id])
    authorize @template
  end

  def template_params
    params.require(:checklist_template).permit(:title, :description, :category, :active)
  end
end
