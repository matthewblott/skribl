import { BridgeComponent } from '@hotwired/hotwire-native-bridge'

export default class extends BridgeComponent {
  static component = 'delete-account'

  submit(event) {
    event.preventDefault()
    event.stopPropagation()

    const form = this.element.form
    const element = this.bridgeElement
    const iosImage = element.bridgeAttribute('ios-image')
    const androidImage = element.bridgeAttribute('android-image')
    const title = element.title || 'Are you sure?'
    const description = element.bridgeAttribute('description')
    const destructive = element.bridgeAttribute('destructive') == 'true'
    const confirm = element.bridgeAttribute('confirm') || 'OK'
    const dismiss = element.bridgeAttribute('dismiss') || 'Cancel'
    const data = {title, description, destructive, confirm, dismiss, iosImage, androidImage}

    this.send('submit', data, () => {
      form.requestSubmit()
    })
  }

}
