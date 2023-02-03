class QuestionReference < ApplicationRecord
  belongs_to :question
  belongs_to :reference
end
