import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this.allSelected = true
    this.setText()
  }

  toggle() {
    this.dispatch("toggle", { detail: this.allSelected })
    this.allSelected = !this.allSelected
    this.setText()
  }
  
  setText() {
    this.element.innerHTML = this.allSelected ? 'Select all' : 'Deselect all'
  }

}
