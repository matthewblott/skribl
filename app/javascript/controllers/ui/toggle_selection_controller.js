import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this.allSelected = false
    this.dispatch("connect")
  }

  update({ detail }) {
    const isNoIds = detail.selectedIds.length === 0 && detail.unselectedIds.length === 0

    if(isNoIds) {
      this.element.innerHTML = 'Select all'
      this.allSelected = false
    }
    else {
      this.element.innerHTML = this.allSelected ? 'Deselect all' : 'Select all'
    }

    this.element.disabled = isNoIds
  }

  toggle() {
    this.allSelected = !this.allSelected
    this.dispatch("toggle", { detail: this.allSelected })
  }

}
