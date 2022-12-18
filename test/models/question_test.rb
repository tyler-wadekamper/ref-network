require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  test "saves a question accepting nested attributes for answer" do
    user = create_user
    answer = build(:answer)
    question = build(:question, author: user, answer:)
    assert question.save
  end

  test "is not valid without an answer" do
    user = create_user
    question = build(:question, author: user)
    assert_not question.valid?
  end

  test "is not valid without an author" do
    answer = build(:answer)
    question = build(:question, answer:)
    assert_not question.valid?
  end

  test "is not valid without a body" do
    user = create_user
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
