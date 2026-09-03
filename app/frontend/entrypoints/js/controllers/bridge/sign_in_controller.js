import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "sign-in"

  connect() {
    super.connect()
    this.#addButton()
  }

  update({ detail }) {
    const title = this.element.innerHTML
    const enabled = detail.isDirty
    const data = {title, enabled}

    this.send('update', data)
  } 

  disconnect() {
    super.disconnect()
    this.#removeButton()
  }

  #addButton() {
    const element = this.bridgeElement
    const title = element.title
    const enabled = true
    const data = {title, enabled}

    this.send('connect', data, (e) => {
      this.element.click()
    })
    // this.dispatch("connect")
  }

  #removeButton() {
    this.send("disconnect")
  }
}
