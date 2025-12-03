import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  submit(e) {
    e.preventDefault()
    this.dispatch("submit")
  }

  update({ detail }) {
    this.element.disabled = detail.length === 0
  }
}
