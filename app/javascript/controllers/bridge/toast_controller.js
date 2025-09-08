import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "toast"

  connect() {
    super.connect()
    const message = this.bridgeElement.bridgeAttribute("message")
    this.send("connect", {message}, () => {})
  }

}
