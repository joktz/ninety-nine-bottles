import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="editor"
export default class extends Controller {
  static targets = [ "editBeerForm" ]
  connect() {
    console.log("Connected to editor controller");
  }

  reveal(event) {
    const targetForm = event.currentTarget.dataset.target;
    console.log(`Revealing ${targetForm}...`);
    this[`${targetForm}Target`].classList.toggle('d-none');
  }

  hide() {
    this.element.classList.toggle('d-none');
  }
}
