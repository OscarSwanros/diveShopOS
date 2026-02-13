# frozen_string_literal: true

class TripDivePolicy < ApplicationPolicy
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

  def destroy?
    true
  end

  class Scope < Scope
    def resolve
      scope.joins(:excursion).where(excursions: { organization_id: user.organization_id })
    end
  end
end
