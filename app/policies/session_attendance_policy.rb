# frozen_string_literal: true

class SessionAttendancePolicy < ApplicationPolicy
  def update?
    true
  end

  def batch_update?
    true
  end

  class Scope < Scope
    def resolve
      scope.joins(class_session: :course_offering)
        .where(course_offerings: { organization_id: user.organization_id })
    end
  end
end
