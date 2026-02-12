# frozen_string_literal: true

class EnrollmentPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    true
  end

  def complete?
    true
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
