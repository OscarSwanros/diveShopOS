# frozen_string_literal: true

require "test_helper"

class Branding::CssVariablesGeneratorTest < ActiveSupport::TestCase
  test "generates CSS with primary color variables" do
    org = organizations(:reef_divers)
    org.brand_primary_color = "#1a73e8"
    org.brand_accent_color = nil

    css = Branding::CssVariablesGenerator.new(org).call

    assert css.start_with?(":root {")
    assert_includes css, "--brand-primary-600:"
    assert_includes css, "--brand-primary-50:"
    assert_includes css, "--brand-primary-950:"
    refute_includes css, "--brand-accent-"
  end

  test "generates CSS with both primary and accent colors" do
    org = organizations(:reef_divers)
    org.brand_primary_color = "#1a73e8"
    org.brand_accent_color = "#059669"

    css = Branding::CssVariablesGenerator.new(org).call

    assert_includes css, "--brand-primary-600:"
    assert_includes css, "--brand-accent-600:"
  end

  test "returns empty string when no brand colors set" do
    org = organizations(:reef_divers)
    org.brand_primary_color = nil
    org.brand_accent_color = nil

    css = Branding::CssVariablesGenerator.new(org).call

    assert_equal "", css
  end

  test "returns empty string for blank brand colors" do
    org = organizations(:reef_divers)
    org.brand_primary_color = ""
    org.brand_accent_color = ""

    css = Branding::CssVariablesGenerator.new(org).call

    assert_equal "", css
  end

  test "generates valid CSS syntax" do
    org = organizations(:reef_divers)
    org.brand_primary_color = "#ff6600"

    css = Branding::CssVariablesGenerator.new(org).call

    assert css.end_with?("}")
    assert_match(/\A:root \{/, css)
    # Each variable should have a hex value
    assert_match(/--brand-primary-\d+: #[0-9a-f]{6}/, css)
  end
end
