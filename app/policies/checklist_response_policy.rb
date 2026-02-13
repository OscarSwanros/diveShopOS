# frozen_string_literal: true

class ChecklistResponsePolicy < ApplicationPolicy
  def update?
    true
  end

  def index?
    true
  end

  def show?
    true
  end
end
