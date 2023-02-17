require "test_helper"

class QuestionViewersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "create action is successful when valid" do
    user = create_random_user
    login_as user
    get questions_url

    csrf_token = @controller.send(:form_authenticity_token)

    create_questions(5)

    post question_viewers_url,
      params: { question_viewer: { viewed_question_id: Question.all.sample.id } },
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrf_token,
      },
      xhr: true,
      as: :json
    
    assert_response :success
  end

  test "create action is unsuccessful when not signed in" do

  end

  test "create action is unsuccessful when question id not present" do

  end

  test "create action is unsuccessful question already viewed" do

  end
end
