class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :authenticate_author, only: [:edit, :update, :destroy]

  def index
    questions = sorted_filtered_questions(sort_filter_params)
    @pagy, @questions = pagy_countless(questions, items: 15, cycle: false)

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

  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    redirect_to questions_url, notice: 'Question deleted successfully.'
  end

  private

  def question_params
    params.require(:question).permit(:body, :id, :commit, reference_ids: [],
                                     answer_attributes: %i[team down distance yardline_num yardline_team clock_status explanation id])
  end

  def sort_filter_params
    params.permit(:sort_by, :filter_by)
  end

  def authenticate_author
    unless Question.find(params[:id]).author == current_user
      flash[:alert] = 'You must be the author of a question to edit or delete.'
      redirect_to root_path
    end
  end

  def sorted_filtered_questions(sort_filter_params)
    filter_by = sort_filter_params[:filter_by]
    return filtered_questions(filter_by) if filter_by

    sort_by = sort_filter_params[:sort_by]
    return sorted_questions(sort_by) if sort_by

    Question.order(created_at: :desc)
  end

  def filtered_questions(filter_by)
    viewed_questions = Question.joins(:question_viewers).where(question_viewers: { viewer_id: current_user.id })

    questions = viewed_questions if filter_by == "read"
    questions = Question.all.excluding(viewed_questions) if filter_by == "unread"

    questions.order(created_at: :desc)
  end

  def sorted_questions(sort_by)
    return Question.order(created_at: :desc) if sort_by == "newest"
    return Question.order(created_at: :asc) if sort_by == "oldest"
    if sort_by == "upvotes"
      return Question.left_joins(:upvotes)
              .group(:id)
              .order('COUNT(upvotes.id) DESC') 
    end
    if sort_by == "downvotes"
      return Question.left_joins(:downvotes)
              .group(:id)
              .order('COUNT(downvotes.id) DESC')
    end    
  end
end
