import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "notice"

  connect() {
    super.connect()
    this.#showToast()
  }

  #showToast() {
    const message = this.bridgeElement.bridgeAttribute("message")
    this.send("show", {message}, () => {})
  }
}
