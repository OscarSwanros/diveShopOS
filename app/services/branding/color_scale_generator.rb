# frozen_string_literal: true

module Branding
  class ColorScaleGenerator
    SCALE_LIGHTNESS = {
      50 => 0.95, 100 => 0.90, 200 => 0.80, 300 => 0.70,
      400 => 0.60, 500 => 0.50, 600 => 0.40, 700 => 0.30,
      800 => 0.20, 900 => 0.15, 950 => 0.10
    }.freeze

    WHITE_LUMINANCE = 1.0

    def initialize(hex_color)
      @hex = hex_color.to_s.strip
    end

    def call
      return {} unless valid_hex?

      h, s, _ = hex_to_hsl(@hex)
      SCALE_LIGHTNESS.transform_values { |l| hsl_to_hex(h, s, l) }
    end

    def contrast_ratio(hex1, hex2)
      l1 = relative_luminance(hex1)
      l2 = relative_luminance(hex2)
      lighter = [ l1, l2 ].max
      darker  = [ l1, l2 ].min
      (lighter + 0.05) / (darker + 0.05)
    end

    def wcag_aa?(hex_color, on_white: true)
      bg = on_white ? "#ffffff" : hex_color
      fg = on_white ? hex_color : "#ffffff"
      contrast_ratio(fg, bg) >= 4.5
    end

    private

    def valid_hex?
      @hex.match?(/\A#[0-9a-fA-F]{6}\z/)
    end

    def hex_to_rgb(hex)
      hex = hex.delete("#")
      [ hex[0..1], hex[2..3], hex[4..5] ].map { |c| c.to_i(16) }
    end

    def rgb_to_hex(r, g, b)
      "#%02x%02x%02x" % [ r.clamp(0, 255).round, g.clamp(0, 255).round, b.clamp(0, 255).round ]
    end

    def hex_to_hsl(hex)
      r, g, b = hex_to_rgb(hex).map { |c| c / 255.0 }
      max = [ r, g, b ].max
      min = [ r, g, b ].min
      l = (max + min) / 2.0

      if max == min
        h = s = 0.0
      else
        d = max - min
        s = l > 0.5 ? d / (2.0 - max - min) : d / (max + min)
        h = case max
        when r then ((g - b) / d) + (g < b ? 6.0 : 0.0)
        when g then ((b - r) / d) + 2.0
        when b then ((r - g) / d) + 4.0
        end
        h /= 6.0
      end

      [ h, s, l ]
    end

    def hsl_to_hex(h, s, l)
      if s == 0
        v = (l * 255).round
        return rgb_to_hex(v, v, v)
      end

      q = l < 0.5 ? l * (1.0 + s) : l + s - l * s
      p = 2.0 * l - q

      r = hue_to_rgb(p, q, h + 1.0 / 3.0)
      g = hue_to_rgb(p, q, h)
      b = hue_to_rgb(p, q, h - 1.0 / 3.0)

      rgb_to_hex((r * 255), (g * 255), (b * 255))
    end

    def hue_to_rgb(p, q, t)
      t += 1.0 if t < 0
      t -= 1.0 if t > 1
      return p + (q - p) * 6.0 * t if t < 1.0 / 6.0
      return q if t < 1.0 / 2.0
      return p + (q - p) * (2.0 / 3.0 - t) * 6.0 if t < 2.0 / 3.0
      p
    end

    def relative_luminance(hex)
      r, g, b = hex_to_rgb(hex).map do |c|
        c = c / 255.0
        c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055)**2.4
      end
      0.2126 * r + 0.7152 * g + 0.0722 * b
    end
  end
end
