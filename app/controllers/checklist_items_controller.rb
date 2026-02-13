# frozen_string_literal: true

class ChecklistItemsController < ApplicationController
  before_action :set_template
  before_action :set_item, only: [ :edit, :update, :destroy ]

  def new
    @item = @template.checklist_items.build(position: next_position)
    authorize @template, :update?
  end

  def create
    @item = @template.checklist_items.build(item_params)
    authorize @template, :update?

    if @item.save
      redirect_to @template, notice: I18n.t("checklist_items.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @template, :update?
  end

  def update
    authorize @template, :update?

    if @item.update(item_params)
      redirect_to @template, notice: I18n.t("checklist_items.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @template, :update?
    @item.destroy
    redirect_to @template, notice: I18n.t("checklist_items.deleted")
  end

  private

  def set_template
    @template = current_organization.checklist_templates.find_by!(slug: params[:checklist_template_id])
  end

  def set_item
    @item = @template.checklist_items.find_by!(slug: params[:id])
  end

  def item_params
    params.require(:checklist_item).permit(:title, :description, :position, :required)
  end

  def next_position
    (@template.checklist_items.maximum(:position) || -1) + 1
  end
end
