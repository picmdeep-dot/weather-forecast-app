import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static values = { mode: String }
  connect() {
    this.update()
  }
  update() {
    const ipRow = this.querySelector('[data-field="ip"]')
    const addrRow = this.querySelector('[data-field="address"]')
    const mode = this.querySelector('input[name="mode"]:checked')?.value || "address"
    ipRow.style.display = mode === "ip" ? "block" : "none"
    addrRow.style.display = mode === "address" ? "block" : "none"
  }
}