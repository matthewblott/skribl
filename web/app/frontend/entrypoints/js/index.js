import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { registerControllers } from "stimulus-vite-helpers"
import { controllers } from "@joemasilotti/bridge-components"

const application = Application.start()
application.debug = false
window.Stimulus = application

const localControllers = import.meta.glob("./**/*_controller.js", { eager: true })
registerControllers(application, localControllers)

application.load(controllers)

export { application }
