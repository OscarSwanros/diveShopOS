# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  class_methods do
    def slugged_by(source, scope:)
      @slug_source = source
      @slug_scope = scope

      before_validation :generate_slug, on: :create
      before_validation :regenerate_slug_if_source_changed, on: :update
      validates :slug, presence: true, uniqueness: { scope: scope }
    end

    attr_reader :slug_source, :slug_scope
  end

  def to_param
    slug
  end

  private

  def generate_slug
    return if slug.present?

    base = compute_slug_base
    self.slug = resolve_slug_collision(base)
  end

  def regenerate_slug_if_source_changed
    source = self.class.slug_source
    changed = if source.is_a?(Proc)
      true # always regenerate for proc sources since we can't track changes
    else
      Array(source).any? { |attr| saved_change_to_attribute?(attr) || will_save_change_to_attribute?(attr) }
    end

    return unless changed

    base = compute_slug_base
    new_slug = resolve_slug_collision(base)
    self.slug = new_slug if new_slug != slug
  end

  def compute_slug_base
    source = self.class.slug_source
    raw = if source.is_a?(Proc)
      instance_exec(&source)
    elsif source.is_a?(Symbol)
      send(source)
    else
      source
    end

    raw.to_s.truncate(80, omission: "").parameterize.presence || "record"
  end

  def resolve_slug_collision(base)
    scope_hash = build_scope_conditions
    candidate = base
    counter = 2

    while slug_exists?(candidate, scope_hash)
      candidate = "#{base}-#{counter}"
      counter += 1
    end

    candidate
  end

  def build_scope_conditions
    Array(self.class.slug_scope).each_with_object({}) do |scope_attr, hash|
      hash[scope_attr] = send(scope_attr)
    end
  end

  def slug_exists?(candidate, scope_hash)
    scope = self.class.where(slug: candidate).where(scope_hash)
    scope = scope.where.not(id: id) if persisted?
    scope.exists?
  end
end
