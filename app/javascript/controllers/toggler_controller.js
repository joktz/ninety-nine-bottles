import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggler"
export default class extends Controller {
  static targets = [ "playerForm", "beerForm" ]

  connect() {
    console.log("Connected to toggler controller");
  }

  toggle(event) {
    const targetForm = event.currentTarget.dataset.target;
    console.log("Toggling ${targetForm}...");
    this.hideAllForms();
    this.showForm(targetForm);
  }

  hideAllForms() {
    this.playerFormTarget.classList.add('d-none');
    this.beerFormTarget.classList.add('d-none');
  }

  showForm(targetForm) {
    this[`${targetForm}Target`].classList.toggle('d-none');
  }
}
