class UpvotesController < ApplicationController
  before_action :authenticate_user!

  def create
    upvote = current_user.upvotes.new(question_id: params[:question_id])
    if upvote.save
      render json: { success: true, net_votes: upvote.question.net_votes }
    else
      render json: { success: false, error: upvote.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def destroy
    upvote = current_user.upvotes.find_by(question_id: params[:question_id])
    if upvote&.destroy
      render json: { success: true, net_votes: upvote.question.net_votes }
    else
      render json: { success: false, error: "Couldn't find upvote" }, status: :unprocessable_entity
    end
  end
end