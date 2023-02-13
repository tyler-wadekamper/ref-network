class QuestionViewersController < ApplicationController
  def create
    @viewed_question = Question.find(question_viewer_params[:viewed_question_id])
    @viewer = User.find(question_viewer_params[:viewer_id])
    QuestionViewer.create(viewer_id: @viewer.id, viewed_question_id: @viewed_question.id) unless already_exists
  end

  private

  def question_viewer_params
    params.permit(:authenticity_token, :viewer_id, :viewed_question_id, :commit)
  end

  def already_exists
    @viewer.viewed_questions.include?(@viewed_question)
  end
end
