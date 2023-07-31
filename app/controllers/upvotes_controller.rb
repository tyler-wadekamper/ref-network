class UpvotesController < ApplicationController
  before_action :authenticate_user!

  def create
    upvote = current_user.upvotes.find_by(question_id: params[:question_id])
    downvote = current_user.downvotes.find_by(question_id: params[:question_id])

    if upvote
      render json: { success: false, error: "Already upvoted", net_votes: upvote.question.net_votes }
    elsif downvote
      downvote.destroy
      new_upvote = current_user.upvotes.new(question_id: params[:question_id])
      if new_upvote.save
        render json: { success: true, net_votes: new_upvote.question.net_votes }
      else
        render json: { success: false, error: new_upvote.errors.full_messages.join(", "), status: :unprocessable_entity }
      end
    else
      new_upvote = current_user.upvotes.new(question_id: params[:question_id])
      if new_upvote.save
        render json: { success: true, net_votes: new_upvote.question.net_votes }
      else
        render json: { success: false, error: new_upvote.errors.full_messages.join(", "), status: :unprocessable_entity }
      end
    end
  end
end
