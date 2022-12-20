require "test_helper"

# These tests are designed to verify the HTML contents of requests and their responses for each view.
# Any functionality that relies on javascript or requires UI interaction should be tested in system/feature_tests

class QuestionPartialTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  class UnauthenticatedTest < QuestionPartialTest
    setup do
      @user = create_default_user
      sign_in @user

      post questions_url, params: VALID_QUESTION_PARAMS
      sign_out @user

      get questions_url(Question.first.id)
    end

    test "shows the first and last name of author" do
      author = Question.first.author
      assert_select "turbo-frame.question" do
        assert_select "div.author-name", "#{author.first_name} #{author.last_name}"
      end
    end
  
    test "shows the time elapsed since the question was posted" do
      assert_select "turbo-frame.question" do
        assert_select "div.time-elapsed", "Posted less than a minute ago"
      end
    end

    test "shows the time elapsed since the question was edited" do
      sign_in @user
      patch question_url(Question.first.id), params: VALID_UPDATE_PARAMS
      get questions_url(Question.first.id)
      
      assert_select "turbo-frame.question" do
        assert_select "div.time-elapsed", "Edited less than a minute ago"
      end
    end

    test "shows the question body" do
      assert_select "turbo-frame.question" do
        assert_select "div.body", "#{Question.first.body}"
      end
    end

    test "shows the show answer button" do
      assert_select "turbo-frame.question" do
        assert_select "button.answer-button", "Show Answer"
      end
    end

    test "the answer content is present" do
      assert_select "turbo-frame.question" do
        assert_select "div.answer", "#{Question.first.answer.text}"
        assert_select "div.explanation", "#{Question.first.answer.explanation}"
      end
    end

    test "does not show the edit button" do
      assert_select "turbo-frame.question" do
        assert_select "a", { count: 0, text: "Edit" }
      end
    end
  end

  class AuthenticatedTest < QuestionPartialTest
    setup do
      @user = create_default_user
      sign_in @user
      post questions_url, params: VALID_QUESTION_PARAMS

      get questions_url(Question.first.id)
    end

    test "shows the edit button" do
      assert_select "turbo-frame.question" do
        assert_select "a", { count: 1, text: "Edit" }
      end
    end
  end

  class AuthenticatedSecondUserTest < QuestionPartialTest
    setup do
      user = create_default_user
      sign_in user
      post questions_url, params: VALID_QUESTION_PARAMS
      sign_out user

      user2 = create_random_user
      sign_in user2

      get questions_url(Question.first.id)
    end

    test "does not show the edit button" do
      assert_select "turbo-frame.question" do
        assert_select "a", { count: 0, text: "Edit" }
      end
    end
  end
end