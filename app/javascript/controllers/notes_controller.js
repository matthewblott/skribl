import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  
  static targets = ['deleteForm', 'deleteButton']

  connect() {
    this.ids = []
    this.deleteButtonTarget.disabled = true
    this.allSelected = false
  }

  getId = (str) => str.replace(/^note_/, '')

  bulkDelete(e) {
    e.preventDefault()
    this.deleteFormTarget.submit()
  }

  toggleSelection(e) {
    const notes = this.element.querySelectorAll('div[id^="note_"]')
    const target = e.currentTarget

    this.ids = []    

    if(this.allSelected) {
      notes.forEach(note => {
        note.classList.remove('selected')
        this.remove(this.getId(note.id))
      })
      target.innerHTML = 'Select all'
    } else {
      notes.forEach(note => {
        const id = this.getId(note.id)
        this.ids.push(id)
        this.add(id)
        note.classList.add('selected')
      })
      target.innerHTML = 'Deselect all'
    }
    this.allSelected = !this.allSelected
    this.updateDeleteButton()
  }

  select(e) {
    const target = e.currentTarget
    const id = this.getId(target.id)

    if (this.ids.includes(id)) {
      this.ids = this.ids.filter(i => i !== id)
      target.classList.remove('selected')
      this.remove(id)
    } else {
      this.ids.push(id)
      target.classList.add('selected')
      this.add(id)
    }

    this.updateDeleteButton()
  }

  add(id) {
    const input = document.createElement("input")
    input.type = "hidden"
    input.name = "ids[]"
    input.value = id
    input.dataset.idValue = id  // helps us find/remove it later
    this.deleteFormTarget.appendChild(input)
    // this.deleteButtonTarget.appendChild(input)
  }

  remove(id) {
    const input = this.deleteButtonTarget.querySelector(`[data-id-value="${id}"]`)
    if (input){
      input.remove()
    }
  }

  updateDeleteButton() {
    const shouldDisable = this.ids.length === 0
    
    if (this.deleteDisabled !== shouldDisable) {
      this.deleteDisabled = shouldDisable
      this.deleteButtonTarget.disabled = shouldDisable
    }

  }

}

