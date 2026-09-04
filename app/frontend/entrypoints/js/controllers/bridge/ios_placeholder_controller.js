import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "ios-placeholder"

  connect() {
    super.connect()
    this.send("connect")
  }

  disconnect() {
    super.disconnect()
    this.send("disconnect")
  }
}
