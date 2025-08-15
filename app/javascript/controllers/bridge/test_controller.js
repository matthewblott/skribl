import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "test"

  connect() {
    super.connect()
    console.log('Test connected')
    // this.#addButton()
  }

  disconnect() {
    super.disconnect()
    // this.#removeButton()
  }

  foo() {
    // const element = this.bridgeElement
    // const iosImage = element.bridgeAttribute("ios-image")
    // const androidImage = element.bridgeAttribute("android-image")
    // const data = {title: element.title, iosImage, androidImage}

    const data = {title: "foo"}
    this.send("connect", data, () => {
      console.log('foo')
      // this.element.click()
    })
  }

  // #removeButton() {
  //   this.send("disconnect")
  // }
}

