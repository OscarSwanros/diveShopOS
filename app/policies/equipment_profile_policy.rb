# frozen_string_literal: true

class EquipmentProfilePolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    user.manager? || user.owner?
  end

  class Scope < Scope
    def resolve
      scope.joins(:customer).where(customers: { organization_id: user.organization_id })
    end
  end
end
