import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    viewer: String,
    viewed: String,
  };

  async postQuestionViewer(event) {
    event.preventDefault();
    const questionId = this.viewedValue;

    const authenticityToken = document.querySelector(
      'meta[name="csrf-token"]'
    ).content;

    const response = await fetch("/question_viewers", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": authenticityToken,
      },
      body: JSON.stringify({
        question_viewer: {
          viewed_question_id: questionId,
        },
      }),
    });
  }
}
