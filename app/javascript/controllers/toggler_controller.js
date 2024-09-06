import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggler"
export default class extends Controller {
  static targets = [ "playerForm", "beerForm", "editBeerForm" ]

  connect() {
    console.log("Connected to toggler controller");
  }

  toggle(event) {
    const targetForm = event.currentTarget.dataset.target;
    console.log(`Hiding rendered forms...`);
    this.hideAllExcept(targetForm);
    console.log(`Toggling ${targetForm}...`);
    this[`${targetForm}Target`].classList.toggle('d-none');
  }

  hideAllExcept(targetForm) {
    if (targetForm !== 'playerForm') {
      this.playerFormTarget.classList.add('d-none');
    }
    if (targetForm !== 'beerForm') {
      this.beerFormTarget.classList.add('d-none');
    }
  }
}
