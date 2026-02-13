# frozen_string_literal: true

class UserInvitationPolicy < ApplicationPolicy
  def new?
    user.owner?
  end

  def create?
    user.owner?
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
