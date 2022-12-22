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

  def fill_in_question(valid: true)
    fake_body = Faker::Lorem.paragraph

    body_content = fake_body if valid
    body_content = "" unless valid

    fill_in "question[body]", with: body_content

    select VALID_TEAMS.sample, from: "question[answer_attributes][team]"
    select VALID_DOWNS.sample, from: "question[answer_attributes][down]"
    select VALID_DISTANCE.sample, from: "question[answer_attributes][distance]"
    select VALID_TEAMS.sample, from: "question[answer_attributes][yardline_team]"
    select VALID_YARDLINE_NUM.sample, from: "question[answer_attributes][yardline_num]"
    select VALID_CLOCK_STATUS.sample, from: "question[answer_attributes][clock_status]"

    fill_in "question[answer_attributes][explanation]", with: Faker::Lorem.paragraph
    body_content
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
      @user2 = create_random_user
      sign_in @user2
      visit questions_url
      click_on "New Question"
    end

    class SuccessfulAddTest < AddQuestionTest
      test "creates a new question" do
        body_content = fill_in_question(valid: true)

        click_on "Create Question"

        sleep(0.5)

        question = Question.order("created_at").last
        answer = question.answer

        within "turbo-frame#question_#{question.id}" do
          assert_selector "div.author-name", { count: 1, text: "#{@user2.first_name} #{@user2.last_name}" }
          assert_selector "div.body", { count: 1, text: body_content }
          assert_answer_content(answer)
        end
      end
    end

    class UnsuccessfulAddTest < AddQuestionTest
      test "does not create a question" do
        fill_in_question(valid: false)

        click_on "Create Question"

        within "turbo-frame#new_question" do
          assert_selector "div.errors" do
            assert_selector ".text-danger", text: "1 error prohibited this question from being saved:"
          end
        end

        assert_selector "div.main-text"
        assert_selector "div.answer"
        assert_selector "div.submit-button"
      end
    end
  end
end
