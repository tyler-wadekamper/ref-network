class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :authenticate_author, only: [:edit, :update]

  def index
    @pagy, @questions = pagy_countless(Question.order(created_at: :desc), items: 15, cycle: false)

    render "scrollable_list" if params[:page]
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
    params.require(:question).permit(:body, :id, :commit,
                                     answer_attributes: %i[team down distance yardline_num yardline_team clock_status explanation id])
  end

  def authenticate_author
    flash[:alert] = 'You must be the author of a question to edit.'
    redirect_to root_path unless Question.find(params[:id]).author == current_user
  end
end
