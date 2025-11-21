import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "signed-out"

  connect() {
    super.connect()
    this.send("connected")
  }

}

