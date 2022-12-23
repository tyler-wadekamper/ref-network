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
      click_on "commit"
      user
    end

    class SuccessfulRegistrationTest < RegistrationTest
      test "creates a new user" do
        user = fill_in_new_user_fields(valid: true)

        assert_selector "div.alert-success", text: "Welcome! You have signed up successfully."
        assert_selector "li", text: "Logged in as #{user.first_name} #{user.last_name}"
      end
    end

    class UnsuccessfulRegistrationTest < RegistrationTest
      test "does not create a new user" do
        fill_in_new_user_fields(valid: false)

        within "div#error_explanation" do
          assert_selector "*", text: "1 error prohibited this user from being saved:"
          assert_selector "li", text: "First name can't be blank"
        end
      end
    end
  end
  
  class SignInTest < UserFeatureTest
    setup do
      @user = create_default_user
      visit new_user_session_url
    end

    def fill_in_sign_in_fields(valid: true)
      fill_in "Email", with: @user.email
      fill_in "Password", with: "UserOnePass" if valid
      fill_in "Password", with: "InvalidPassword" unless valid
      click_on "commit"
    end
    class SuccessfulSignInTest < SignInTest
      test "signs in successfully" do
        fill_in_sign_in_fields(valid: true)

        assert_selector "div.alert-success", text: "Signed in successfully."
        assert_selector "li", text: "Logged in as #{@user.first_name} #{@user.last_name}"
      end
    end

    class UnsuccessfulSignInTest < SignInTest
      test "does not sign in" do
        fill_in_sign_in_fields(valid: false)

        assert_selector "div.alert-danger", text: "Invalid Email or password."
        assert_selector "input#user_email"
        assert_selector "input#user_password"
      end
    end
  end

  # class PasswordResetTest < UserFeatureTest
  #   setup do
  #     visit new_user_password_url
  #   end

  #   test "sends the password reset email" do

  #   end
  # end
end