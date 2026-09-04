import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

export default class extends BridgeComponent {
  static component = "sign-out"

  connect() {
    super.connect()
    // this.#addButton()
  }

  disconnect() {
    super.disconnect()
    // this.#removeButton()
  }

  foo(e) {
    e.preventDefault() 
    // this.send("click")
    
    const data = {}

    this.send("foo", data, () => {
      // this.element.click()
      document.getElementById('sign_out_form').submit()
    })

  }

  // #addButton() {
  //   const element = this.bridgeElement
  //   const iosImage = element.bridgeAttribute("ios-image")
  //   const androidImage = element.bridgeAttribute("android-image")
  //   const data = {title: element.title, iosImage, androidImage}
  //
  //   this.send("connect", data, () => {
  //     document.getElementById('sign_out_form').click()
  //   })
  // }

  // #removeButton() {
  //   this.send("disconnect")
  // }
}
