class DownvotesController < ApplicationController
  before_action :authenticate_user!

  def create
    downvote = current_user.downvotes.new(question_id: params[:question_id])
    if downvote.save
      render json: { success: true, net_votes: downvote.question.net_votes }
    else
      render json: { success: false, error: downvote.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def destroy
    downvote = current_user.downvotes.find_by(question_id: params[:question_id])
    if downvote&.destroy
      render json: { success: true, net_votes: downvote.question.net_votes }
    else
      render json: { success: false, error: "Couldn't find downvote" }, status: :unprocessable_entity
    end
  end
end