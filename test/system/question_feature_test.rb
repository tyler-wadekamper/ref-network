require "application_system_test_case"

# These tests are high-level tests that simulate user interaction with main workflows.
# Any response/request tests that do not rely on UI interaction or javascript should be tested in test/integration.

class QuestionFeatureTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  def assert_answer_content(answer)
    click_on "Show Answer"
    assert_selector "div.answer", text: answer.text
    assert_selector "div.explanation", text: answer.explanation
    assert_selector "button.answer-button", text: "Hide Answer"
  end

  def assert_references_content(question)
    click_on "Show Rule References"
    question.references.each do |reference|
      assert_selector 'a', text: /.*#{reference.name}/ if reference.name
      assert_selector 'span', text: reference.text
    end
  end

  def fill_in_question(valid: true, edit: false)
    fake_body = Faker::Lorem.paragraph

    body_content = fake_body if valid
    body_content = "" unless valid

    fill_in "question[body]", with: body_content

    select_valid_answer_fields
    select_random_reference_fields unless edit

    fill_in "question[answer_attributes][explanation]", with: Faker::Lorem.paragraph
    body_content
  end

  def select_valid_answer_fields
    select VALID_TEAMS.sample, from: "question[answer_attributes][team]"
    select VALID_DOWNS.sample, from: "question[answer_attributes][down]"
    select VALID_DISTANCE.sample, from: "question[answer_attributes][distance]"
    select VALID_TEAMS.sample, from: "question[answer_attributes][yardline_team]"
    select VALID_YARDLINE_NUM.sample, from: "question[answer_attributes][yardline_num]"
    select VALID_CLOCK_STATUS.sample, from: "question[answer_attributes][clock_status]"
  end

  def select_random_reference_fields(count: 5)
    find('div.ss-main').click
    Reference.all.sample(count).each do |reference|
      fill_in "Search", with: reference.text
      find('div.ss-option', text: reference.label).click
    end

    find('span.ss-cross').click if has_css?('span.ss-cross')
  end

  def assert_question_content(question, body_content)
    answer = question.answer

    within "turbo-frame#question_#{question.id}" do
      assert_selector "div.author-name", { count: 1, text: "#{@user2.first_name} #{@user2.last_name}" }
      assert_selector "div.body", { count: 1, text: body_content }
      assert_answer_content(answer)
      assert_references_content(question)
    end
  end

  def assert_errors_present(question: nil)
    question_id = "question_#{question.id}" if question
    question_id = "new_question" unless question

    within "turbo-frame##{question_id}" do
      assert_selector "div.errors" do
        assert_selector ".text-danger", text: "1 error prohibited this question from being saved:"
      end
    end
  end

  def assert_answer_fields_present
    assert_selector "div.main-text"
    assert_selector "div.answer"
    assert_selector "div.submit-button"
  end

  class QuestionListTest < QuestionFeatureTest
    setup do
      create_sample_references('6')
      create_questions(50)
    end



    test "shows the list of questions on scroll" do
      visit questions_url
      assert_scroll_functionality
    end
  end

  class AnswerReferenceButtonTest < QuestionFeatureTest
    setup do
      create_sample_references('6')
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

    test "shows the reference for the first three questions" do
      visit questions_url
      Question.limit(3).order(created_at: :desc).each do |question|
        within "turbo-frame#question_#{question.id}" do
          assert_references_content(question)
        end
      end
    end
  end

  class AddQuestionTest < QuestionFeatureTest
    setup do
      create_sample_references('6')
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
        assert_question_content(question, body_content)
      end
    end

    class UnsuccessfulAddTest < AddQuestionTest
      test "does not create a question" do
        fill_in_question(valid: false)

        click_on "Create Question"

        assert_errors_present
        assert_answer_fields_present

        visit questions_url
        assert_selector "div.author-name", { count: 0, text: "#{@user2.first_name} #{@user2.last_name}" }
      end
    end
  end

  class EditQuestionTest < QuestionFeatureTest
    setup do
      create_sample_references('6')
      create_questions(20)
      @user2 = create_random_user
      sign_in @user2
      create_questions(1, author: @user2)
      visit questions_url
      click_on "Edit"
    end
    class SuccessfulEditTest < EditQuestionTest
      def update_and_check_question(body_content)
        click_on "Update Question"

        sleep(0.5)

        question = Question.order("updated_at").last
        assert_question_content(question, body_content)
      end

      test "updates the question" do
        body_content = fill_in_question(valid: true, edit: true)
        update_and_check_question(body_content)
      end

      test "adds a reference to the question" do
        body_content = fill_in_question(valid: true, edit: true)
        select_random_reference_fields(count: 1)
        update_and_check_question(body_content)
      end

      test "removes a reference from the question" do
        body_content = fill_in_question(valid: true, edit: true)
        first('span.ss-value-delete').click
        update_and_check_question(body_content)
      end
    end

    class UnsuccessfulEditTest < EditQuestionTest
      test "does not update the question" do
        fill_in_question(valid: false, edit: true)

        click_on "Update Question"

        sleep(0.5)

        question = Question.order("updated_at").last

        assert_errors_present(question:)
        assert_answer_fields_present

        visit questions_url
        assert_selector "div.time-elapsed", { count: 0, text: "Edited less than a minute ago" }
        assert_selector "div.author-name", { count: 1, text: "#{@user2.first_name} #{@user2.last_name}" }
      end
    end
  end
end
