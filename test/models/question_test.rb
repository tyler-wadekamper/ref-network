require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  test "saves a question accepting nested attributes for answer" do
    user = create_default_user
    answer = build(:answer)
    question = build(:question, author: user, answer:)
    assert question.save
    assert question.answer.instance_of?(Answer)
  end

  test "saves a question with references by accepting reference_id attributes" do
    user = create_default_user
    answer = build(:answer)
    create_sample_references('6')
    reference_ids = Reference.first(5).map(&:id)
    question = build(:question, author: user, answer:, reference_ids:)

    assert question.save
    question.references.each do |ref|
      assert ref.instance_of?(Reference)
    end
    assert_equal 5, question.references.count
  end

  test "is not valid without an answer" do
    user = create_default_user
    question = build(:question, author: user)
    assert_not question.valid?
  end

  test "is not valid without an author" do
    answer = build(:answer)
    question = build(:question, answer:)
    assert_not question.valid?
  end

  test "is not valid without a body" do
    user = create_default_user
    answer = build(:answer)

    EMPTY_VALUES.each do |value|
      question = build(:question, author: user, answer:, body: value)
      assert_not question.valid?
    end
  end

  test "errors are present when no params are provided" do
    question = Question.new
    question.save
    assert_not_empty question.errors
  end
end
