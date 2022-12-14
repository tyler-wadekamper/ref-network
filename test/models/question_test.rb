require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  test "saves a question accepting nested attributes for answer" do
    user = create(:default_user)
    question = build(:question, author: user)
    assert question.save
  end
end
