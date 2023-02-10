class Question < ApplicationRecord
  validates_presence_of :answer, :body

  belongs_to :author, class_name: 'User'
  has_one :answer, dependent: :destroy

  has_many :question_references
  has_many :references, through: :question_references

  has_many :question_viewers, foreign_key: :viewed_question_id
  has_many :viewers, through: :question_viewers, class_name: 'User'

  accepts_nested_attributes_for :answer

  def references_by_rule_order
    references.all.sort_by(&:created_at)
  end
end
