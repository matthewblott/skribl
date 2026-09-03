import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const attributes = this.element.attributes
    const dataValue = attributes.getNamedItem('data-value')
    if(dataValue !== undefined) {
      this.dispatch("update")
    }
  }
  
}
