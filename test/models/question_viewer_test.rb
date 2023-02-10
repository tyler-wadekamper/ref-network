require "test_helper"

class QuestionViewerTest < ActiveSupport::TestCase
  setup do
    @users = create_list(:random_user, 5)
    create_questions(5)
    @questions = Question.all
  end

  test "#viewers returns list of users who have viewed" do
    @questions.each do |question|
      @users.each do |user|
        question.viewers << user
      end
    end

    @users.each do |user|
      assert_equal user.viewed_questions, @questions
    end
  end

  test "#viewed_questions returns list of questions viewed" do
    @questions.each do |question|
      @users.each do |user|
        user.viewed_questions << question
      end
    end

    @questions.each do |question|
      assert_equal question.viewers, @users
    end
  end
end
