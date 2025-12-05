import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this.allSelected = false
  }

  update({ detail }) {
    if(detail.selectedIds.length === 0 && detail.unselectedIds.length === 0) {
      this.element.innerHTML = 'Select all'
      this.allSelected = false
    }
    else {
      this.element.innerHTML = this.allSelected ? 'Deselect all' : 'Select all'
    }
  }

  toggle() {
    this.allSelected = !this.allSelected
    this.dispatch("toggle", { detail: this.allSelected })
  }

}
