class Reference < ApplicationRecord
  validates_presence_of :rule

  has_many :question_references
  has_many :questions, through: :question_references
end
