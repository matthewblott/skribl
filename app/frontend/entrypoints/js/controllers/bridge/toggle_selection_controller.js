import { BridgeComponent } from '@hotwired/hotwire-native-bridge'

export default class extends BridgeComponent {
  static component = 'toggle-selection'

  connect() {
    this.allSelected = false
    super.connect()
    this.#addButton()
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

    const title = this.element.innerHTML
    const enabled = !isNoIds
    const data = {title, enabled}

    this.send('update', data, (e) => {
    })

  }

  disconnect() {
    super.disconnect()
    this.removeButton()
  }

  #addButton() {
    const title = this.element.innerHTML
    const enabled = !this.element.disabled 
    const data = {title, enabled}

    this.send('connect', data, (e) => {
      if(e.data.info  === 'user tapped native button 1') {
        this.allSelected = !this.allSelected
      }
      this.element.click()
    })
    this.dispatch("connect")
  }

  removeButton() {
    this.send('disconnect')
  }

}
