# frozen_string_literal: true

class OnboardingPolicy < ApplicationPolicy
  def manage?
    user.owner?
  end

  def dismiss?
    user.owner?
  end
end
