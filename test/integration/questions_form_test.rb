require "test_helper"

# These tests are designed to verify the HTML contents of requests and their responses for each view.
# Any functionality that relies on javascript or requires UI interaction should be tested in system/feature_tests

class QuestionsFormTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  class QuestionsEditTest < QuestionsFormTest
    class InitialFormTest < QuestionsEditTest
      setup do
        user = create_default_user
        sign_in user
        post questions_url, params: VALID_QUESTION_PARAMS
        get edit_question_url(Question.first.id)
      end

      test "renders form partial" do
        assert_template partial: "_form"
      end

      test "shows update question button" do
        assert_select "input[value=?]", "Update Question"
      end
    end

    class FailedFormTest < QuestionsEditTest
      setup do
        user = create_default_user
        sign_in user
        post questions_url, params: VALID_QUESTION_PARAMS
        patch question_url(Question.first.id), params: INVALID_QUESTION_PARAMS
      end

      test "renders form partial" do
        assert_template partial: "_form"
      end
    end
  end

  class QuestionsNewTest < QuestionsFormTest
    class EmptyFormTest < QuestionsNewTest
      setup do
        user = create_default_user
        sign_in user
        get new_question_url
      end

      test "renders form partial" do
        assert_template partial: "_form"
      end

      test "shows field for body" do
        assert_select "label.body", "Main text"
        assert_select "textarea.body", ""
      end

      test "shows label for answer" do
        assert_select "label.answer", "Answer"
      end

      test "shows select for team" do
        assert_select "select" do
          VALID_TEAMS.each do |team|
            assert_select "option", team
            assert_select "option[value=?]", team
          end
        end
      end

      test "shows select for down" do
        assert_select "select" do
          VALID_DOWNS.each do |down|
            assert_select "option", down
            assert_select "option[value=?]", down
          end
        end
      end

      test "shows select for distance" do
        assert_select "select" do
          VALID_DISTANCE.each do |distance|
            assert_select "option", distance
            assert_select "option[value=?]", distance
          end
        end
      end

      test "shows select for yardline team" do
        assert_select "select" do
          VALID_TEAMS.each do |team|
            assert_select "option", team
            assert_select "option[value=?]", team
          end
        end
      end

      test "shows select for yardline number" do
        assert_select "select" do
          VALID_YARDLINE_NUM.each do |num|
            assert_select "option", num
            assert_select "option[value=?]", num
          end
        end
      end

      test "shows select for clock status" do
        assert_select "select" do
          VALID_CLOCK_STATUS.each do |status|
            assert_select "option", status
            assert_select "option[value=?]", status
          end
        end
      end

      test "shows field for explanation" do
        assert_select "label.explanation", "Explanation"
        assert_select "textarea.explanation", ""
      end

      test "shows cancel button" do
        assert_select "a[href=?]", "/questions"
      end

      test "does not show errors" do
        assert_select "div.errors", { count: 0 }
      end

      test "shows create question button" do
        assert_select "input[value=?]", "Create Question"
      end
    end

    class FailedFormTest < QuestionsNewTest
      setup do
        user = create_default_user
        sign_in user
        get new_question_url
        post questions_url, params: INVALID_QUESTION_PARAMS
      end

      test "renders form partial" do
        assert_template partial: "_form"
      end

      test "shows errors" do
        assert_select "div.errors" do
          assert_select ".text-danger", { count: 2 }
        end
      end
    end
  end
end