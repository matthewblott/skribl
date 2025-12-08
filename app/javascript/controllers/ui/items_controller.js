import { Controller } from '@hotwired/stimulus'

export default class extends Controller {

  connect() {
    this.itemName = 'note'
    // this.update()
    window.addEventListener("stimulus:update", () => this.update())
  }

  toggle({ detail }) {
    if(detail) {
      this.#selectAll()
    } else {
      this.#deselectAll()
    }
    this.update()
  }

  select(e) {
    const item = e.currentTarget
    const isSelected = item.hasAttribute('selected')

    if(isSelected) {
      this.#deselectItem(item)
    } else {
      this.#selectItem(item)
    }
    this.update()
  }

  update() {
    const allItems = this.#getItems()
    const selectedElements = Array.from(allItems).filter(el => el.hasAttribute('selected'))
    const unselectedElements = Array.from(allItems).filter(el => !el.hasAttribute('selected'))
    const selectedIds = Array.from(selectedElements).map(el => this.#getId(el.id))
    const unselectedIds = Array.from(unselectedElements).map(el => this.#getId(el.id))

    this.dispatch("update", {
      detail: {
        selectedIds: selectedIds,
        unselectedIds: unselectedIds
      } 
    }) 
  }

  #getId (str) {
    const uuidPattern = '[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}'
    const re = new RegExp(`(?<=${this.itemName}_)${uuidPattern}`)
    return str.match(re)?.[0]
  }

  #getItems = () => this.element.querySelectorAll(`div[id^="${this.itemName}_"]`)

  #selectAll () {
    const items = this.#getItems()
    items.forEach(item => {
      this.#selectItem(item)
    })
  }
  
  #deselectAll () {
    const items = this.#getItems()
    items.forEach(item => {
      this.#deselectItem(item)
    })
  } 
  
  #selectItem(item) {
    item.setAttribute('selected', '')
    item.classList.add('selected')
  }
  
  #deselectItem(item) {
    item.removeAttribute('selected')
    item.classList.remove('selected')
  }

}
