require "test_helper"

class QuestionReferenceTest < ActiveSupport::TestCase
  test "#references returns list of associated references" do
    question_references = create_list(:random_reference, 3)

    user = create_default_user
    answer = build(:answer)
    question = build(:question, author: user, answer:)

    question_references.each do |reference|
      reference.questions << question
    end

    assert_equal question.references, question_references
  end

  test "#questions returns list of referenced questions" do
    user = create_default_user
    answer = build(:answer)
    referenced_questions = create_list(:question, 3, author: user, answer:)

    reference = build(:default_reference)
    referenced_questions.each do |question|
      question.references << reference
    end

    assert_equal reference.questions, referenced_questions
  end
end
