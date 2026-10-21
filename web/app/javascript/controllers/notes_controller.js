import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['item', 'selectAllButton', 'deleteButton', 'form']

  connect() {
    this.allSelected = false
  }

  toggleAll() {
    this.allSelected = !this.allSelected
    this.itemTargets.forEach(item => this.setSelected(item, this.allSelected))
    this.refreshDeleteButton()
  }

  select(event) {
    const item = event.currentTarget
    this.setSelected(item, !item.hasAttribute('selected'))
    this.refreshDeleteButton()
  }

  setSelected(item, selected) {
    item.toggleAttribute('selected', selected)
    item.classList.toggle('selected', selected)
  }

  get selectedIds() {
    return this.itemTargets
      .filter(item => item.hasAttribute('selected'))
      .map(item => item.dataset.id)
  }

  refreshDeleteButton() {
    this.deleteButtonTarget.disabled = this.selectedIds.length === 0
  }

  submitDelete(event) {
    event.preventDefault()
    this.formTarget.querySelectorAll('input[name="ids[]"]').forEach(el => el.remove())
    this.selectedIds.forEach(id => {
      const input = document.createElement('input')
      input.type = 'hidden'
      input.name = 'ids[]'
      input.value = id
      this.formTarget.appendChild(input)
    })
    this.formTarget.requestSubmit()
  }
}
