# frozen_string_literal: true

class TripParticipantPolicy < ApplicationPolicy
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

  def review?
    user.manager? || user.owner?
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
