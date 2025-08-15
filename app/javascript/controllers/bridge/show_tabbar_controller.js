import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "show-tabbar"

  connect() {
    super.connect()
  }

  disconnect() {
    super.disconnect()
  }

  foo() {
    const data = {title: "foo"}
    this.send("connect", data, () => {
      console.log('foo')
    })
  }
}

