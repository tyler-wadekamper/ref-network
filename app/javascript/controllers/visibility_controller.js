import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["hideable", "button"];

  toggleVisibility() {
    this.hideableTargets.forEach((el) => {
      el.hidden = !el.hidden;
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
