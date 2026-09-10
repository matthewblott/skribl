import { BridgeComponent } from '@hotwired/hotwire-native-bridge'

export default class extends BridgeComponent {
  static component = 'unauthenticated'

  connect() {
    super.connect()
    this.send('connect')
  }
}

