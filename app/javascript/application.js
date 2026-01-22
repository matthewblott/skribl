// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { application } from "controllers/application"
import "@rails/request.js"

Turbo.StreamActions.clear_canvas = function() {
  const element = document.querySelector('[data-controller~="note"]')
  const controller = application.getControllerForElementAndIdentifier(
    element,
    "note"
  )
  
  if (controller) {
    controller.clear()
  }
}
