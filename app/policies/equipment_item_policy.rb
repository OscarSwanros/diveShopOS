# frozen_string_literal: true

class EquipmentItemPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.manager? || user.owner?
  end

  def update?
    user.manager? || user.owner?
  end

  def destroy?
    user.owner?
  end

  class Scope < Scope
    def resolve
      scope.where(organization_id: user.organization_id)
    end
  end
end
