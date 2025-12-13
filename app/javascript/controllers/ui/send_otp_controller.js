import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this.element.disabled = true
  }
  
  update({ detail }) {
    this.element.disabled = !detail.enabled 
  }

}
