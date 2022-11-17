class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.build_answer
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to questions_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])

    if @question.update(question_params)
      redirect_to questions_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:body,
                                     answer_attributes: %i[team down distance yardline_num yardline_team clock_status explanation])
  end
end
