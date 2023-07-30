import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["down", "distance", "form"];

  connect() {
    this.checkAndUpdateDistanceDropdown();

    // Attach event listeners
    this.downTarget.addEventListener(
      "change",
      this.checkAndUpdateDistanceDropdown.bind(this)
    );
    this.formTarget.addEventListener(
      "submit",
      this.enableDistanceDropdown.bind(this)
    );
  }

  checkAndUpdateDistanceDropdown() {
    if (this.downTarget.value === "FK") {
      this.distanceTarget.value = "";
      this.distanceTarget.disabled = true;
    } else {
      this.distanceTarget.disabled = false;
    }
  }

  enableDistanceDropdown(event) {
    this.distanceTarget.disabled = false;
  }
}
