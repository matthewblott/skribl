import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "clear-canvas"

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
    const title = this.element.innerHTML
    const enabled = false
    const data = {title, enabled}

    this.send('connect', data, (e) => {
      data.enabled = false 
      this.send('update', data)
      this.element.click()
    })
    this.dispatch("connect")
  }

  #removeButton() {
    this.send("disconnect")
  }
}
