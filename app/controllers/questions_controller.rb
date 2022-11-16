class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to questions_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:body, :commit)
  end
end
