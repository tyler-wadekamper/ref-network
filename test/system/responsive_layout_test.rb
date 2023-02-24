require "application_system_test_case"
class ResponsiveLayoutTest < MobileSystemTestCase
  include Devise::Test::IntegrationHelpers

  test "clicking navbar expand when not signed in shows the log in and sign up buttons" do
    visit questions_url
    find("button.navbar-toggler").click

    assert_selector "button", text: "Log in"
    assert_selector "button", text: "Sign up"
  end

  test "clicking navbar expand when signed in shows the log out button" do
    @user = create_random_user
    sign_in @user
    visit questions_url

    find("button.navbar-toggler").click
    find("#navbarUserDropdown").click

    assert_selector "button", text: "Log out"
  end
end