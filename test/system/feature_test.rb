require "application_system_test_case"

# These tests are high-level tests that simulate user interaction with main workflows.
# Any response/request tests that do not rely on UI interaction or javascript should be tested in test/integration.

class FeatureTest < ApplicationSystemTestCase
  def create_questions(number)
    user = create_default_user
    number.times do
      answer = build(:random_answer)
      create(:random_question, author: user, answer:)
    end
  end

  class QuestionListTest < FeatureTest
    setup do
      create_questions(50)
    end

    def scroll_down
      page.execute_script "window.scrollBy(0,10000)"
    end

    def assert_questions(number)
      assert_selector "turbo-frame.question", count: number
    end

    test "shows the list of questions on scroll" do
      visit questions_url
      assert_questions(15)

      scroll_down
      assert_questions(30)

      scroll_down
      assert_questions(45)

      scroll_down
      assert_questions(50)
    end
  end

  class AnswerButtonTest < FeatureTest
    setup do
      create_questions(20)
    end

    test "shows the answer for the first three questions" do
      visit questions_url
      Question.limit(3).order(created_at: :desc).each do |question|
        answer = question.answer
        within "turbo-frame#question_#{question.id}" do
          click_on "Show Answer"
          assert_selector "div.answer", text: answer.text
          assert_selector "div.explanation", text: answer.explanation
        end
      end
    end
  end
end
