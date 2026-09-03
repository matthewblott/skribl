import { Controller } from '@hotwired/stimulus'

export default class extends Controller {

  update({ detail }) {
    this.#removeAllFields()
    detail.selectedIds.forEach(id => {
      this.addField(id)
    })
  }

  submit() {
    this.element.submit()
  }

  addField(id) {
    const input = document.createElement("input")
    input.type = "hidden"
    input.name = "ids[]"
    input.value = id
    this.element.appendChild(input)
  }

  #getFields() {
    return this.element.querySelectorAll(`input[name="ids[]`)
  }

  #removeAllFields() {
    this.#getFields().forEach(el => el.remove())
  }

}
