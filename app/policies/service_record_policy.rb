# frozen_string_literal: true

class ServiceRecordPolicy < ApplicationPolicy
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
    user.manager? || user.owner?
  end

  class Scope < Scope
    def resolve
      scope.joins(:equipment_item).where(equipment_items: { organization_id: user.organization_id })
    end
  end
end
