import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="answer-checker"
export default class extends Controller {
  static targets = ["answer", "submit"]

  connect() {
    console.log("Answer Checker Controller Loaded");
    this.checkAnswers();
  }

  checkAnswers() {
    const answers = []
    let hasDuplicates = false;
    let hasEmptyFields = false;

    this.answerTargets.forEach(field => {
      if (field.value === "") {
        hasEmptyFields = true;
      } else if (answers.includes(field.value)) {
        hasDuplicates = true;
      } else {
        answers.push(field.value);
      }
    });

    this.submitTarget.disabled = hasDuplicates || hasEmptyFields;
  }

  answerChanged() {
    this.checkAnswers();
  }
}
