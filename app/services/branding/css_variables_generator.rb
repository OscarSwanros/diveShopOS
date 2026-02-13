# frozen_string_literal: true

module Branding
  class CssVariablesGenerator
    def initialize(organization)
      @org = organization
    end

    def call
      vars = []

      if @org.brand_primary_color.present?
        scale = ColorScaleGenerator.new(@org.brand_primary_color).call
        scale.each { |step, hex| vars << "--brand-primary-#{step}: #{hex}" }
      end

      if @org.brand_accent_color.present?
        scale = ColorScaleGenerator.new(@org.brand_accent_color).call
        scale.each { |step, hex| vars << "--brand-accent-#{step}: #{hex}" }
      end

      vars.any? ? ":root { #{vars.join('; ')}; }" : ""
    end
  end
end
