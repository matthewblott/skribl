import { BridgeComponent } from '@hotwired/hotwire-native-bridge'

export default class extends BridgeComponent {
  static component = 'toggle-note-selection'

  connect() {
    super.connect()
    this.#addButton()
    // this.allSelected = true
    // this.setText()
  }

  disconnect() {
    super.disconnect()
    this.removeButton()
  }

  #addButton() {
    const element = this.bridgeElement
    // const iosImage = element.bridgeAttribute('ios-image')
    // const androidImage = element.bridgeAttribute('android-image')
    // const title = element.title || 'Are you sure?'
    const title = 'Select all'
    // const description = element.bridgeAttribute('description')
    // const destructive = element.bridgeAttribute('destructive') == 'true'
    // const confirm = element.bridgeAttribute('confirm') || 'OK'
    // const dismiss = element.bridgeAttribute('dismiss') || 'Cancel'
    // const data = {title, description, destructive, confirm, dismiss, iosImage, androidImage}
    const data = {title}

    this.send('connect', data, () => {
      this.element.click()
    })
  }

  update({ detail }) {
    this.element.disabled = detail.selectedIds.length === 0
  }

  // toggle() {
  //   this.dispatch("toggle", { detail: this.allSelected })
  //   this.allSelected = !this.allSelected
  //   this.setText()
  // }

  // setText() {
  //   this.element.innerHTML = this.allSelected ? 'Select all' : 'Deselect all'
  // }

  removeButton() {
    this.send('disconnect')
  }

}

