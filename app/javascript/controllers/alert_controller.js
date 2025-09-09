import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   connect() {
//     setTimeout(() => this.element.remove(), 3000)
//   }
// }

export default class extends Controller {
  connect() {
    // Clean URL parameters when alert appears
    this.cleanUrl()
    
    setTimeout(() => this.element.remove(), 3000)
  }
  
  cleanUrl() {
    const url = new URL(window.location)
    let urlChanged = false
    
    if (url.searchParams.has('note_deleted')) {
      url.searchParams.delete('note_deleted')
      urlChanged = true
    }
    
    if (url.searchParams.has('message')) {
      url.searchParams.delete('message')
      urlChanged = true
    }
    
    if (urlChanged) {
      window.history.replaceState({}, document.title, url.toString())
    }
  }
}
