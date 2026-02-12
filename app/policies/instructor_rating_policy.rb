# frozen_string_literal: true

class InstructorRatingPolicy < ApplicationPolicy
  def index?
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
      scope.joins(:user).where(users: { organization_id: user.organization_id })
    end
  end
end
