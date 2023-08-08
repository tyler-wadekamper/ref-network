class DownvotesController < ApplicationController
  before_action :authenticate_user!

  def create
    downvote = current_user.downvotes.find_by(question_id: params[:question_id])
    upvote = current_user.upvotes.find_by(question_id: params[:question_id])

    if downvote
      render json: { success: false, error: "Already downvoted", net_votes: downvote.question.net_votes }
    elsif upvote
      upvote.destroy
      new_downvote = current_user.downvotes.new(question_id: params[:question_id])
      if new_downvote.save
        render json: { success: true, net_votes: new_downvote.question.net_votes }
      else
        render json: { success: false, error: new_downvote.errors.full_messages.join(", "), status: :unprocessable_entity }
      end
    else
      new_downvote = current_user.downvotes.new(question_id: params[:question_id])
      if new_downvote.save
        render json: { success: true, net_votes: new_downvote.question.net_votes }
      else
        render json: { success: false, error: new_downvote.errors.full_messages.join(", "), status: :unprocessable_entity }
      end
    end
  end
end