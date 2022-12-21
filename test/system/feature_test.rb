require "application_system_test_case"

# These tests are high-level tests that simulate user interaction with main workflows.
# Any response/request tests that do not rely on UI interaction or javascript should be tested in test/integration.

class FeatureTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  def create_questions(number)
    @user = create_default_user
    number.times do
      answer = build(:random_answer)
      create(:random_question, author: @user, answer:)
    end
  end

  def assert_answer_content(answer)
    click_on "Show Answer"
    assert_selector "div.answer", text: answer.text
    assert_selector "div.explanation", text: answer.explanation
    assert_selector "button.answer-button", text: "Hide Answer"
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
          assert_answer_content(answer)
        end
      end
    end
  end

  class AddQuestionTest < FeatureTest
    setup do
      create_questions(20)
    end

    class SuccessfulAddTest < AddQuestionTest
      test "creates a new question" do
        user2 = create_random_user
        sign_in user2
        visit questions_url

        click_on "New Question"

        fake_body = Faker::Lorem.paragraph

        fill_in "question[body]", with: fake_body

        select VALID_TEAMS.sample, from: "question[answer_attributes][team]"
        select VALID_DOWNS.sample, from: "question[answer_attributes][down]"
        select VALID_DISTANCE.sample, from: "question[answer_attributes][distance]"
        select VALID_TEAMS.sample, from: "question[answer_attributes][yardline_team]"
        select VALID_YARDLINE_NUM.sample, from: "question[answer_attributes][yardline_num]"
        select VALID_CLOCK_STATUS.sample, from: "question[answer_attributes][clock_status]"

        fill_in "question[answer_attributes][explanation]", with: Faker::Lorem.paragraph

        click_on "Create Question"

        question = Question.order("created_at").last
        answer = question.answer

        within "turbo-frame#question_#{question.id}" do
          assert_selector "div.author-name", text: "#{@user.first_name} #{@user.last_name}"
          assert_answer_content(answer)
        end

        assert_selector "div.body", { count: 1, text: fake_body }
      end
    end

    class UnsuccessfulAddTest < AddQuestionTest
    end
  end
end
