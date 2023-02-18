require "test_helper"
class QuestionViewersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def request_create
    post question_viewers_url,
    params: { question_viewer: { viewed_question_id: Question.first.id } },
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": @csrf_token,
    },
    xhr: true,
    as: :json
  end

  setup do
    @user = create_random_user
    sign_in @user
    get questions_url
    @csrf_token = @controller.send(:form_authenticity_token)
    create_questions(5)
  end

  test "create action is successful when valid" do
    assert_difference('QuestionViewer.count') do
      request_create
    end
    assert_response :success
  end

  test "create action is unsuccessful when not signed in" do
    sign_out @user

    assert_no_difference('QuestionViewer.count') do
      request_create
    end
    assert_response :unauthorized
  end

  test "create action is unsuccessful question already viewed" do
    assert_difference('QuestionViewer.count') do
      request_create
    end
    assert_response :success

    assert_no_difference('QuestionViewer.count') do
      request_create
    end
    assert_response :bad_request
  end
end