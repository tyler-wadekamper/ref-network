class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, foreign_key: :author_id, class_name: 'Question'

  has_many :question_viewers, foreign_key: :viewer_id
  has_many :viewed_questions, through: :question_viewers, class_name: 'Question'

  validates_presence_of :first_name, :last_name, :email

  before_save do
    capitalize_names
  end

  def viewed?(question)
    viewed_questions.include?(question)
  end

  private

  def capitalize_names
    self.first_name = first_name.capitalize
    self.last_name = last_name.capitalize
  end
end
