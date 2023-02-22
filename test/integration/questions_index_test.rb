require "test_helper"

# These tests are designed to verify the HTML contents of requests and their responses for each view.
# Any functionality that relies on javascript or requires UI interaction should be tested in system/feature_tests

class QuestionsIndexTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  class UnauthenticatedTest < QuestionsIndexTest
    setup do
      get questions_url
    end

    test "shows the navbar" do
      assert_select "nav.navbar", 1
      assert_select "a", "RefNetwork"
    end

    test "shows the new question button" do
      assert_select "button", "New question"
    end

    test "shows the log in and sign up buttons" do
      assert_select "button", "Sign up"
      assert_select "button", "Log in"
    end
  end

  class AuthenticatedTest < QuestionsIndexTest
    setup do
      @user = create_default_user
      sign_in @user
      get questions_url
    end

    test "shows the user's name" do
      assert_select "nav" do
        assert_select "li", "#{@user.first_name} #{@user.last_name}"
      end
    end

    test "shows the log out button" do
      assert_select "button", "Log out"
    end
  end
end
