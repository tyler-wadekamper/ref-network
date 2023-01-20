class ReferencesController < ApplicationController
  def search
    if params.dig(:reference_search).present?
      @references = Reference.where('text ILIKE ?', "#{params[:reference_search]}%")
      @references += Reference.where('name ILIKE ?', "%#{params[:reference_search]}%")
    else
      @references = []
    end

    new_references = []
    @references.each do |reference|
      new_references << reference.parent if reference.parent
      new_references += reference.children if reference.children
    end
    
    @references += new_references
    @references = @references.uniq.sort_by(&:created_at)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("search_results",
          partial: "references/search_results",
          locals: { references: @references })
        ]
      end
    end
  end

  def show
    @reference = Reference.find(params[:id])

    references = Reference.where("text LIKE ?", "#{@reference.text}%") # your query to get the set of references
    questions = Question.joins(:references).where(references: {id: references.pluck(:id)})

    @pagy, @questions = pagy_countless(questions.order(created_at: :desc), items: 15, cycle: false)

    render "scrollable_list" if params[:page]
  end
end