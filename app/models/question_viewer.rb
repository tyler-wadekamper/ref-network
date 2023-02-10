class QuestionViewer < ApplicationRecord
  belongs_to :viewer, foreign_key: :viewer_id, class_name: 'User'
  belongs_to :viewed_question, foreign_key: :viewed_question_id, class_name: 'Question'
end
