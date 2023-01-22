class Reference < ApplicationRecord
  validates_presence_of :rule

  has_many :question_references
  has_many :questions, through: :question_references

  belongs_to :parent, class_name: 'Reference', optional: true
  has_many :children, class_name: 'Reference', foreign_key: 'parent_id'

  before_save do
    self.text = create_text
    self.length = create_length
    self.label = create_label
  end

  def child_questions
    child_references = Reference.where("text LIKE ?", "#{self.text}%")
    Question.joins(:references).where(references: {id: child_references.pluck(:id)})
  end

  private

  def create_text
    total_text = "#{rule}"
    total_text += "-#{section}" if section
    total_text += "-#{article}" if article
    total_text += ".#{subarticle}" if subarticle
    total_text
  end

  def create_length
    return 1 if section.nil?
    return 2 if article.nil?
    return 3 if subarticle.nil?

    return 4
  end

  def create_label
    return text + " - " + name unless name.nil?

    text
  end
end
