import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggler"
export default class extends Controller {
  static targets = [ "playerForm", "beerForm", "editBeerForm" ]

  connect() {
    console.log("Connected to toggler controller");
  }

  toggle(event) {
    // Adding conditional to dynamically summon edit form for specific beers
    if (event.currentTarget.dataset.target === 'editBeerForm') {
      const beerId = event.currentTarget.dataset.beerId;
      console.log(beerId);
      const editBeerForm = this.editBeerFormTargets.find(target => target.dataset.beerId === beerId);
      console.log(editBeerForm);
      this.hideAllExcept(editBeerForm);
      editBeerForm.classList.toggle('d-none');
    } else {
      const targetForm = event.currentTarget.dataset.target;
      this.hideAllExcept(targetForm);
      this[`${targetForm}Target`].classList.toggle('d-none');
    }
  }


  hideAllExcept(targetForm) {
    if (targetForm !== 'playerForm') {
      this.playerFormTarget.classList.add('d-none');
    }
    if (targetForm !== 'beerForm') {
      this.beerFormTarget.classList.add('d-none');
    }
    this.editBeerFormTargets.forEach(target => {
      if (target !== targetForm) {
        target.classList.add('d-none');
      }
    });
  }
}
