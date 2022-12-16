require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  test "saves a question accepting nested attributes for answer" do
    user = create(:default_user)
    answer = build(:answer)
    question = build(:question, author: user, answer:)
    assert question.valid?
  end

  test "does not save without an answer" do
    user = create(:default_user)
    question = build(:question, author: user)
    assert_not question.valid?
  end

  test "does not save without an author" do
    answer = build(:answer)
    question = build(:question, answer:)
    assert_not question.valid?
  end

  test "does not save without a body" do
    user = create(:default_user)
    answer = build(:answer)
    question = build(:question, author: user, answer:, body: "")
    assert_not question.valid?
  end

  test "errors are present when no params are provided" do
    question = Question.new
    question.save
    assert_not_empty question.errors
  end
end
