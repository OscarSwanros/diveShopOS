# frozen_string_literal: true

class ClassSessionPolicy < ApplicationPolicy
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
      scope.joins(:course_offering).where(course_offerings: { organization_id: user.organization_id })
    end
  end
end
