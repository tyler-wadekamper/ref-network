import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["hideable", "button"];

  toggleAnswerVisibility() {
    this.hideableTargets.forEach((el) => {
      if (el.classList.contains("answer-container")) {
        el.hidden = !el.hidden;
      }
    });
  }

  toggleReferencesVisibility() {
    this.hideableTargets.forEach((el) => {
      if (el.classList.contains("references-container")) {
        el.hidden = !el.hidden;
      }
    });
  }

  toggleAnswerButton() {
    let target = this.buttonTarget;
    if (target.textContent == "Show Answer") {
      target.textContent = "Hide Answer";
    } else {
      target.textContent = "Show Answer";
    }
  }
}
