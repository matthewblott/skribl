import { BridgeComponent } from '@hotwired/hotwire-native-bridge'

export default class extends BridgeComponent {
  static component = 'delete-note'

  connect() {
    super.connect()
    this.#addButton()
  }

  disconnect() {
    super.disconnect()
    this.removeButton()
  }

  #addButton() {
    const element = this.bridgeElement
    const iosImage = element.bridgeAttribute('ios-image')
    const androidImage = element.bridgeAttribute('android-image')
    const title = element.title || 'Are you sure?'
    const description = element.bridgeAttribute('description')
    const destructive = element.bridgeAttribute('destructive') == 'true'
    const confirm = element.bridgeAttribute('confirm') || 'OK'
    const dismiss = element.bridgeAttribute('dismiss') || 'Cancel'
    const enabled = false

    const data = {
      title,
      description,
      destructive,
      confirm,
      dismiss,
      enabled,
      iosImage,
      androidImage,
      enabled
    }

    this.send('connect', data, () => {
      this.dispatch("submit")
    })
  }

  removeButton() {
    this.send('disconnect')
  }

  update({ detail }) {
    const element = this.bridgeElement
    const iosImage = element.bridgeAttribute('ios-image')
    const androidImage = element.bridgeAttribute('android-image')
    const title = element.title || 'Are you sure?'
    const description = element.bridgeAttribute('description')
    const destructive = element.bridgeAttribute('destructive') == 'true'
    const confirm = element.bridgeAttribute('confirm') || 'OK'
    const dismiss = element.bridgeAttribute('dismiss') || 'Cancel'
    const enabled = detail.selectedIds.length > 0

    const data = {
      title,
      description,
      destructive,
      confirm,
      dismiss,
      enabled,
      iosImage,
      androidImage,
      enabled
    }

    this.send("toggleEnabled", data, () => {
      console.log('Toggle executed')
    })
  }

}
