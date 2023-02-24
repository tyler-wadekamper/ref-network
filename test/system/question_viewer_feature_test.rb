require "application_system_test_case"

class QuestionViewerFeatureTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    ActionController::Base.allow_forgery_protection = true
    create_sample_references('6')
    create_questions(15)
  end

  teardown do
    ActionController::Base.allow_forgery_protection = false
  end

  test "shows question as read after clicking on the answer" do
    @user = create_random_user
    sign_in @user

    visit questions_url

    question_id = Question.last.id
    assert_selector "#question_#{question_id}_viewer", text: /.*Unread question\z/

    within "#question_#{question_id}" do
      click_on "Show Answer"
    end

    assert_selector "#question_#{question_id}_viewer", text: /.*Read question\z/
  end

  test "question remains read in new session" do
    @user = create_random_user
    sign_in @user

    visit questions_url

    question_id = Question.last.id
    assert_selector "#question_#{question_id}_viewer", text: /.*Unread question\z/

    within "#question_#{question_id}" do
      click_on "Show Answer"
      sleep(0.5)
    end
    assert_selector "#question_#{question_id}_viewer", text: /.*Read question\z/

    find("#navbarUserDropdown").click
    click_on "Log out"
    sleep(0.5)
    sign_in @user
    visit questions_url
    assert_selector "#question_#{question_id}_viewer", text: /.*Read question\z/
  end
end