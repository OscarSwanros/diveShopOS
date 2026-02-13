import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobileMenu"]

  connect() {
    this.closeMobileMenu = this.closeMobileMenu.bind(this)
    document.addEventListener("turbo:visit", this.closeMobileMenu)
  }

  disconnect() {
    document.removeEventListener("turbo:visit", this.closeMobileMenu)
  }

  toggle() {
    this.mobileMenuTarget.classList.toggle("hidden")
  }

  closeMobileMenu() {
    this.mobileMenuTarget.classList.add("hidden")
  }
}
