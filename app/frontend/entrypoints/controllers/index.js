import { Application } from "@hotwired/stimulus"

const application = Application.start()
application.debug = false
window.Stimulus = application

const controllers = import.meta.glob("./**/*_controller.js", { eager: true })
for (const path in controllers) {
  const name = path
    .replace("./", "")
    .replace("_controller.js", "")
    .replace(/\//g, "--")
  application.register(name, controllers[path].default)
}

export { application }
