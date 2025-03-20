import { Controller } from "@hotwired/stimulus"
// import { ocr } from 'ocr'
// import { work } from 'worker'

export default class extends Controller {

  // static targets = ['canvas', 'text', 'submit', 'img'];
  static targets = ['canvas', 'text', 'submit', 'img'];

  initialize() {
    // ocr()
  }

  clear() {
    this.canvasTarget.getContext('2d').clearRect(0, 0, this.canvasTarget.width, this.canvasTarget.height);
    // this.textTarget.innerText = ''
  }

  async toText() {
    const canvas = this.canvasTarget.toDataURL('image/png')
    // const text = await work(canvas)
    // this.textTarget.value = text
    this.imgTarget.value = canvas
    this.submitTarget.click()
    // console.log(text)
  }

}

