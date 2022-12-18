require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  VALID_QUESTION_PARAMS = { question: { body: "new question",
                                        answer_attributes: { team: "A", 
                                                             down: "1", 
                                                             distance: "10", 
                                                             yardline_team: "A", 
                                                             yardline_num: "25", 
                                                             clock_status: "Ready", 
                                                             explanation: "" }}}

  test "index action is successful" do
    get questions_url
    assert_response :success
    assert_not_nil assigns(:questions)
  end

  test "new action is successful when signed in" do
    user = build_user
    sign_in user
    get new_question_url
    assert_response :success
  end

  test "new action redirects to sign in page when not signed in" do
    get new_question_url
    assert_redirected_to new_user_session_path
    assert_equal 'You must be signed in to create a question.', flash[:alert]
  end

  test "routes to index after successful creation" do
    user = create_user
    sign_in user
    assert_difference('Question.count') do
      post questions_url, params: VALID_QUESTION_PARAMS
    end

    assert_redirected_to questions_url
  end

  test "routes to new question after unsuccessful creation" do
    user = create_user
    sign_in user

    INVALID_QUESTION_PARAMS = VALID_QUESTION_PARAMS
    INVALID_QUESTION_PARAMS[:body] = ""

    assert_no_difference('Question.count') do
      post questions_url, params: { question: INVALID_QUESTION_PARAMS }
    end

    assert_response :unprocessable_entity
    assert_template :new
  end

  test "edit action is successful" do
    user = create_user
    sign_in user

    post questions_url, params: VALID_QUESTION_PARAMS
    get edit_question_url(Question.first.id)

    assert_response :success
    assert_not_nil assigns(:question)
  end
end
