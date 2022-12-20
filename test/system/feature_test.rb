require "application_system_test_case"

# These tests are high-level tests that simulate user interaction with main workflows.
# Any response/request tests that do not rely on UI interaction or javascript should be tested in test/integration.

class FeatureTest < ApplicationSystemTestCase
  class QuestionListTest < FeatureTest
    setup do
      user = create_default_user
      20.times do
        answer = build(:random_answer)
        create(:random_question, author: user, answer:)
      end
    end

    test "shows the first 15 questions" do
      visit questions_url
      assert_selector "turbo-frame.question", count: 15
    end
  end

  # question scroll test to show more than 15
end
