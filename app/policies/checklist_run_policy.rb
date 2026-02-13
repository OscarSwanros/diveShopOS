# frozen_string_literal: true

class ChecklistRunPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def complete?
    true
  end

  def abandon?
    true
  end

  def destroy?
    user.manager? || user.owner?
  end

  class Scope < Scope
    def resolve
      scope.where(organization_id: user.organization_id)
    end
  end
end
