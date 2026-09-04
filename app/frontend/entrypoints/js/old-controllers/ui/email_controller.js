import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  // Runs on every keystroke / change
  check(e) {
    const input = e.target;
    if (input.checkValidity()) {
      input.classList.remove("is-invalid");
      input.classList.add("is-valid");

      this.dispatch("update", {
        detail: {
          enabled: true
        } 
      }) 
    }
  }

  // Fires only when the field is invalid on submit or blur
  showInvalid(e) {
    e.preventDefault(); // suppress native tooltip
    const input = e.target;
    input.classList.remove("is-valid");
    input.classList.add("is-invalid");

    this.dispatch("update", {
      detail: {
        enabled: false
      } 
    }) 
  }
}
