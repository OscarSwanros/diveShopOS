# frozen_string_literal: true

class EnrollmentPolicy < ApplicationPolicy
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

  def review?
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
