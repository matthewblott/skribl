import { Controller } from "@hotwired/stimulus"
import { ocr } from 'ocr'

export default class extends Controller {

  static targets = ['canvas', 'text', 'submit', 'img']

  initialize() {
    ocr(this.canvasTarget)
  }

  clear() {
    this.canvasTarget.getContext('2d').clearRect(0, 0, this.canvasTarget.width, this.canvasTarget.height)
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
