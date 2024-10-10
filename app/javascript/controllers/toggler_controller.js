import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggler"
export default class extends Controller {
  static targets = [ "playerForm", "beerForm", "editBeerForm", "roundForm", "answerForm" ]

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
    } else if (event.currentTarget.dataset.target === 'answerForm') {
      console.log(this.answerFormTargets);
      const playerId = event.currentTarget.dataset.playerId;
      console.log(playerId);
      const answerForm = this.answerFormTargets.find(target => target.dataset.playerId === playerId);
      console.log(answerForm);
      this.hideAllExcept(answerForm);
      answerForm.classList.toggle('d-none');
    } else {
      const targetForm = event.currentTarget.dataset.target;
      console.log(targetForm);
      this.hideAllExcept(targetForm);
      this[`${targetForm}Target`].classList.toggle('d-none');
    }
  }


  hideAllExcept(targetForm) {
    if (this.hasPlayerFormTarget && targetForm !== 'playerForm') {
      this.playerFormTarget.classList.add('d-none');
    }
    if (this.hasBeerFormTarget && targetForm !== 'beerForm') {
      this.beerFormTarget.classList.add('d-none');
    }
    if (this.hasEditBeerFormTarget && targetForm !== "editBeerForm") {
      this.editBeerFormTargets.forEach(target => {
        if (target !== targetForm) {
          target.classList.add('d-none');
        }
      });
    }
    if (this.hasRoundFormTarget && targetForm !== 'roundForm') {
      this.roundFormTarget.classList.add('d-none');
    }
    if (this.hasAnswerFormTarget && targetForm !== 'answerForm') {
      this.answerFormTargets.forEach(target => {
        if (target !== targetForm) {
          target.classList.add('d-none');
        }
      });
      this.answerFormTarget.classList.add('d-none');
    }
  }
}
