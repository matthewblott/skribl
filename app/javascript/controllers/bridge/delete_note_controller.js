import { BridgeComponent } from '@hotwired/hotwire-native-bridge'

export default class extends BridgeComponent {
  static component = 'delete-note'

  connect() {
    super.connect()
    this.#addButton()
  }

  disconnect() {
    super.disconnect()
    this.#removeButton()
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
    const data = {title, description, destructive, confirm, dismiss, iosImage, androidImage}

    this.send('connect', data, () => {
      this.element.click()
    })
  }

  #removeButton() {
    this.send('disconnect')
  }

  #toggleEnabled() {
    this.send("toggleEnabled", {}, () => {
      // console.log('Toggle executed')
    })
  }

  triggerDelete(e) {
    e.preventDefault()
    const notesEl = document.querySelector("[data-controller~='notes']")
    const notesController = this.application.getControllerForElementAndIdentifier(notesEl, "notes")

    if (notesController) {
      notesController.bulkDelete(e)
    }
  }

}
