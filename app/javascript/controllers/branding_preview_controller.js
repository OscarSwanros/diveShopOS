import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["primaryColor", "primaryHex", "accentColor", "accentHex", "previewButton", "previewLink", "contrastWarning"]

  updatePreview() {
    const color = this.primaryColorTarget.value
    this.primaryHexTarget.value = color
    this.applyPreview(color)
  }

  updateFromHex() {
    const hex = this.primaryHexTarget.value
    if (/^#[0-9a-fA-F]{6}$/.test(hex)) {
      this.primaryColorTarget.value = hex
      this.applyPreview(hex)
    }
  }

  applyPreview(color) {
    if (this.hasPreviewButtonTarget) {
      this.previewButtonTarget.style.backgroundColor = color
    }
    if (this.hasPreviewLinkTarget) {
      this.previewLinkTarget.style.color = color
    }
    this.checkContrast(color)
  }

  checkContrast(hexColor) {
    if (!this.hasContrastWarningTarget) return

    const ratio = this.contrastRatio(hexColor, "#ffffff")
    if (ratio < 4.5) {
      this.contrastWarningTarget.classList.remove("hidden")
    } else {
      this.contrastWarningTarget.classList.add("hidden")
    }
  }

  contrastRatio(hex1, hex2) {
    const l1 = this.relativeLuminance(hex1)
    const l2 = this.relativeLuminance(hex2)
    const lighter = Math.max(l1, l2)
    const darker = Math.min(l1, l2)
    return (lighter + 0.05) / (darker + 0.05)
  }

  relativeLuminance(hex) {
    const rgb = this.hexToRgb(hex).map(c => {
      c = c / 255
      return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4)
    })
    return 0.2126 * rgb[0] + 0.7152 * rgb[1] + 0.0722 * rgb[2]
  }

  hexToRgb(hex) {
    hex = hex.replace("#", "")
    return [
      parseInt(hex.substring(0, 2), 16),
      parseInt(hex.substring(2, 4), 16),
      parseInt(hex.substring(4, 6), 16)
    ]
  }
}
