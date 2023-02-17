class QuestionViewersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @viewed_question = Question.find(question_viewer_params[:viewed_question_id])
    head :bad_request and return if already_exists

    @question_viewer = QuestionViewer.new(viewer_id: current_user.id, viewed_question_id: @viewed_question.id)
    head :accepted and return if @question_viewer.save

    head :unprocessable_entity
  end

  private

  def question_viewer_params
    params.require(:question_viewer).permit(:viewed_question_id)
  end

  def already_exists
    current_user.viewed_questions.include?(@viewed_question)
  end
end
