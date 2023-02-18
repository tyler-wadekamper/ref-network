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
    this.buttonTargets.forEach((el) => {
      if (el.classList.contains("answer-button")) {
        if (el.textContent == "Show Answer") {
          el.textContent = "Hide Answer";
        } else {
          el.textContent = "Show Answer";
        }
      }
    });
  }

  toggleReferencesButton() {
    this.buttonTargets.forEach((el) => {
      if (el.classList.contains("references-button")) {
        if (el.textContent == "Show Rule References") {
          el.textContent = "Hide Rule References";
        } else {
          el.textContent = "Show Rule References";
        }
      }
    });
  }
}
