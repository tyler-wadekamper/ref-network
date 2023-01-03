class Question < ApplicationRecord
  validates_presence_of :answer, :body

  belongs_to :author, class_name: 'User'
  has_one :answer, dependent: :destroy

  has_many :question_references
  has_many :references, through: :question_references

  accepts_nested_attributes_for :answer
end
