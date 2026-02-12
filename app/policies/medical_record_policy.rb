# frozen_string_literal: true

class MedicalRecordPolicy < ApplicationPolicy
  def show?
    user.manager? || user.owner?
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
      scope.joins(:customer).where(customers: { organization_id: user.organization_id })
    end
  end
end
