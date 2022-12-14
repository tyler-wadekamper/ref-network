class Question < ApplicationRecord
  validates_presence_of :answer, :body

  belongs_to :author, class_name: 'User'
  has_one :answer

  accepts_nested_attributes_for :answer
end
