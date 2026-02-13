# frozen_string_literal: true

require "test_helper"

class Branding::ColorScaleGeneratorTest < ActiveSupport::TestCase
  test "generates a full 11-step color scale" do
    generator = Branding::ColorScaleGenerator.new("#1a73e8")
    scale = generator.call

    assert_equal 11, scale.size
    assert_equal [ 50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950 ], scale.keys.sort
  end

  test "all scale values are valid hex colors" do
    generator = Branding::ColorScaleGenerator.new("#1a73e8")
    scale = generator.call

    scale.each_value do |hex|
      assert_match(/\A#[0-9a-f]{6}\z/, hex, "Expected valid hex color, got #{hex}")
    end
  end

  test "lighter steps have higher lightness than darker steps" do
    generator = Branding::ColorScaleGenerator.new("#1a73e8")
    scale = generator.call

    # Step 50 should be lighter (closer to white) than step 950
    r50, g50, b50 = hex_to_rgb(scale[50])
    r950, g950, b950 = hex_to_rgb(scale[950])

    # Lighter colors have higher RGB sum
    assert (r50 + g50 + b50) > (r950 + g950 + b950),
      "Step 50 (#{scale[50]}) should be lighter than step 950 (#{scale[950]})"
  end

  test "returns empty hash for invalid hex color" do
    assert_equal({}, Branding::ColorScaleGenerator.new("invalid").call)
    assert_equal({}, Branding::ColorScaleGenerator.new("").call)
    assert_equal({}, Branding::ColorScaleGenerator.new("#GGG").call)
  end

  test "handles pure white" do
    scale = Branding::ColorScaleGenerator.new("#ffffff").call
    assert_equal 11, scale.size
  end

  test "handles pure black" do
    scale = Branding::ColorScaleGenerator.new("#000000").call
    assert_equal 11, scale.size
  end

  test "wcag_aa? passes for dark color on white" do
    generator = Branding::ColorScaleGenerator.new("#1a73e8")
    # Dark blue should pass against white
    assert generator.wcag_aa?("#1a3a6b")
  end

  test "wcag_aa? fails for light color on white" do
    generator = Branding::ColorScaleGenerator.new("#ffff00")
    refute generator.wcag_aa?("#ffff00")
  end

  test "contrast_ratio returns valid ratio" do
    generator = Branding::ColorScaleGenerator.new("#000000")
    ratio = generator.contrast_ratio("#000000", "#ffffff")

    # Black on white should be 21:1
    assert_in_delta 21.0, ratio, 0.1
  end

  private

  def hex_to_rgb(hex)
    hex = hex.delete("#")
    [ hex[0..1], hex[2..3], hex[4..5] ].map { |c| c.to_i(16) }
  end
end
