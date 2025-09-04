import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "sign-in-success"

  connect() {
    super.connect()
    const data = { value: this.bridgeElement.element.value }
    this.send("authenticated", data)
  }

}
