import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggler"
export default class extends Controller {
  static targets = [ "playerForm" ]

  connect() {
    console.log("Connected to toggler controller");
  }

  toggle() {
    console.log("Toggling...");
    console.log(this.playerFormTarget);
    this.playerFormTarget.classList.toggle('d-none');
  }
}
