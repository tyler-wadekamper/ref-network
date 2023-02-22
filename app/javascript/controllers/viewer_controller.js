import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["viewer"];

  toggleViewer() {
    this.viewerTargets.forEach((el) => {
      console.log(el.textContent);
      if (el.textContent.includes("Unread question")) {
        el.innerHTML = "<i class='bi bi-check-lg'></i> Read question";
        el.classList.add("text-secondary");
      }
    });
  }
}
