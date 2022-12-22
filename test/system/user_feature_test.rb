require "application_system_test_case"

# These tests are high-level tests that simulate user interaction with main workflows.
# Any response/request tests that do not rely on UI interaction or javascript should be tested in test/integration.

class UserFeatureTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  class RegistrationTest < UserFeatureTest
    setup do
      visit new_user_registration_url
    end

    def fill_in_new_user_fields(valid: true)
      user = build_random_user

      fill_in "First name", with: user.first_name if valid
      fill_in "Last name", with: user.last_name
      fill_in "Email", with: user.email
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      user
    end

    class SuccessfulRegistrationTest < RegistrationTest
      test "creates a new user" do
        user = fill_in_new_user_fields(valid: true)

        click_on "commit"

        assert_selector "div.alert-success", text: "Welcome! You have signed up successfully."
        assert_selector "li", text: "Logged in as #{user.first_name} #{user.last_name}"
      end
    end

    class UnsuccessfulRegistrationTest < RegistrationTest
      test "does not create a new user" do
        fill_in_new_user_fields(valid: false)

        click_on "commit"
        
        within "div#error_explanation" do
          assert_selector "*", text: "1 error prohibited this user from being saved:"
          assert_selector "li", text: "First name can't be blank"
        end
      end
    end
  end
  
  # class SignInTest < UserFeatureTest
  #   class SuccessfulSignInTest < SignInTest
  #   end

  #   class UnsuccessfulSignInTest < SignInTest
  #   end
  # end

  # class PasswordResetTest < UserFeatureTest
  # end
end