import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["viewer"];

  toggleViewer() {
    this.viewerTargets.forEach((el) => {
      console.log(el.textContent);
      if (el.textContent.includes("New question")) {
        el.textContent = "Viewed question";
      }
    });
  }
}
