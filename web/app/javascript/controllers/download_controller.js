import { BridgeComponent } from '@hotwired/hotwire-native-bridge'

export default class extends BridgeComponent {
  static component = 'download'

  connect() {
    super.connect()
  }

  submit(e) {
    e.preventDefault()
    const token = this.element.dataset.token
    const data = {
      token
    }
    this.send('connect', data)
  }

}

