import { Controller } from "@hotwired/stimulus"
import { ocr } from 'ocr'

export default class extends Controller {

  static targets = ['canvas', 'text', 'submit', 'img', 'clear', 'save']

  connect() {
    this.canvasTarget.addEventListener("canvas:dirty", this.onDirty)
    this.started = false 
  }

  disconnect() {
    this.canvasTarget.removeEventListener("canvas:dirty", this.onDirty)
  }

  onDirty = () => {
    this.clearTarget.disabled = false
    this.saveTarget.disabled = false 

    if(this.started) {
      return
    }

    // Dispatch event here for the bridge components
    this.dispatch("update", {
      detail: {
        isDirty: true
      } 
    }) 

    this.started = true 
  }

  initialize() {
    ocr(this.canvasTarget)
    this.clearTarget.disabled = true
    this.saveTarget.disabled = true
  }

  clear() {
    this.canvasTarget.getContext('2d').clearRect(0, 0, this.canvasTarget.width, this.canvasTarget.height)
    this.clearTarget.disabled = true
    this.saveTarget.disabled = true

    this.dispatch("update", {
      detail: {
        isDirty: false
      } 
    }) 
    this.started = false
  }

  async create() {
    if(!this.isCanvasDirty()) {
      return
    }

    const canvas = this.canvasTarget.toDataURL('image/png')
    this.imgTarget.value = canvas
    this.submitTarget.click()
    this.clear()
  }

  isCanvasDirty() {
    const ctx = this.canvasTarget.getContext('2d')
    const imageData = ctx.getImageData(0, 0, this.canvasTarget.width, this.canvasTarget.height).data
    
    for (let i = 3; i < imageData.length; i += 4) {
      if (imageData[i] > 0) {
        return true
      }
    }
    
    return false
  }

}
