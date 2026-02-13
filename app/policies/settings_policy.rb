# frozen_string_literal: true

class SettingsPolicy < ApplicationPolicy
  def domain?
    user.owner?
  end

  def branding?
    user.owner?
  end
end
