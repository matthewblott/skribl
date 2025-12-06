import { BridgeComponent } from '@hotwired/hotwire-native-bridge'

export default class extends BridgeComponent {
  static component = 'toggle-selection'

  connect() {
    // this.allSelected = false
    super.connect()
    this.#addButton()
  }

  update({ detail }) {
    // if(detail.selectedIds.length === 0 && detail.unselectedIds.length === 0) {
    //   this.element.innerHTML = 'Select all'
    //   this.allSelected = false
    // }
    // else {
    //   this.element.innerHTML = this.allSelected ? 'Deselect all' : 'Select all'
    // }
    // this.element.disabled = detail.selectedIds.length === 0

    const title = 'Select all'
    const enabled = detail.selectedIds.length > 0
    const data = {title, enabled}

    this.send('enable', data, (e) => {
      console.log('update')
    })
  }

  // toggle() {
  //   this.allSelected = !this.allSelected
  //   this.dispatch("toggle", { detail: this.allSelected })
  // }

  disconnect() {
    super.disconnect()
    this.removeButton()
  }

  #addButton() {
    const title = 'Select all'
    const enabled = true
    const data = {title, enabled}

    this.send('connect', data, (e) => {
      this.element.click()
    })
    this.dispatch("connect")
  }

  removeButton() {
    this.send('disconnect')
  }

}
