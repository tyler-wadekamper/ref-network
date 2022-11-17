class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_one :answer

  accepts_nested_attributes_for :answer
end
