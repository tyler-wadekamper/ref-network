import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["voteCount", "upvoteButton", "downvoteButton"];

  get csrfToken() {
    return document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
  }

  upvote(event) {
    let questionId = this.data.get("id");
    fetch(`/upvotes?question_id=${questionId}`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": this.csrfToken,
        "Content-Type": "application/json",
        Accept: "application/json",
      },
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          this.voteCountTarget.innerText = data.net_votes;
        } else {
          alert(data.error);
        }
      });
    this.toggleVote(true);
  }

  downvote(event) {
    let questionId = this.data.get("id");
    fetch(`/downvotes?question_id=${questionId}`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": this.csrfToken,
        "Content-Type": "application/json",
        Accept: "application/json",
      },
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          this.voteCountTarget.innerText = data.net_votes;
        } else {
          alert(data.error);
        }
      });
    this.toggleVote(false);
  }

  toggleVote(upvoted) {
    this.upvoteButtonTarget.classList.toggle("upvoted", upvoted);
    this.upvoteButtonTarget.disabled = upvoted;

    this.downvoteButtonTarget.classList.toggle("downvoted", !upvoted);
    this.downvoteButtonTarget.disabled = !upvoted;
  }
}
