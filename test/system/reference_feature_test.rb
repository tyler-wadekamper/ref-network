require "application_system_test_case"

# These tests are high-level tests that simulate user interaction with main workflows.
# Any response/request tests that do not rely on UI interaction or javascript should be tested in test/integration.

class ReferenceFeatureTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    create_sample_references('6')
  end

  test "reference link shows all questions for that reference" do
    create_questions(15)
    visit questions_url

    question = Question.last
    reference = question.references.sample
    question_count = reference.questions.count

    click_on 'Show Rule References', match: :first
    first('a', text: reference.label).click
    assert_selector 'div.question-card', count: question_count
  end

  test "reference show page can scroll through multiple pages of questions" do
    reference = Reference.where('text = ?', '6-1-1')[0]
    create_questions(50, reference:)

    visit reference_url(reference.id)
    assert_scroll_functionality
  end
end
