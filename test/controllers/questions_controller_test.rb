require "test_helper"
class QuestionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "index action is successful" do
    get questions_url
    assert_response :success
    assert_not_nil assigns(:questions)
  end

  test "new action is successful when signed in" do
    user = build_default_user
    sign_in user
    get new_question_url
    assert_response :success
  end

  test "new action redirects to sign in page when not signed in" do
    get new_question_url
    assert_redirected_to new_user_session_path
    assert_equal 'You must be signed in to continue.', flash[:alert]
  end

  test "routes to index after successful creation" do
    user = create_default_user
    sign_in user
    assert_difference('Question.count') do
      post questions_url, params: VALID_QUESTION_PARAMS
    end

    assert_redirected_to questions_url
  end

  test "routes to new question after unsuccessful creation" do
    user = create_default_user
    sign_in user

    assert_no_difference('Question.count') do
      post questions_url, params: { question: INVALID_QUESTION_PARAMS }
    end

    assert_response :unprocessable_entity
    assert_template :new
  end

  test "edit action is successful when signed in" do
    user = create_default_user
    sign_in user

    post questions_url, params: VALID_QUESTION_PARAMS
    get edit_question_url(Question.first.id)

    assert_response :success
    assert_not_nil assigns(:question)
  end

  test "edit action is not successful when not signed in" do
    user = create_default_user

    sign_in user
    post questions_url, params: VALID_QUESTION_PARAMS
    sign_out user

    get edit_question_url(Question.first.id)

    assert_redirected_to new_user_session_path
    assert_equal 'You must be signed in to continue.', flash[:alert]
  end

  test "edit action is not successful when not the author" do
    user = create_default_user
    user2 = create(:random_user)

    sign_in user
    post questions_url, params: VALID_QUESTION_PARAMS
    sign_out user

    sign_in user2
    get edit_question_url(Question.first.id)

    assert_redirected_to root_path
    assert_equal 'You must be the author of a question to edit or delete.', flash[:alert]
  end

  test "update action is successful when signed in" do
    user = create_default_user
    sign_in user

    post questions_url, params: VALID_QUESTION_PARAMS
    patch question_url(Question.first.id), params: VALID_UPDATE_PARAMS

    assert_redirected_to questions_url
    assert_equal Question.first.body, "updated question"
    assert_not_nil assigns(:question)
  end

  test "update action is not successful when not signed in" do
    user = create_default_user

    sign_in user
    post questions_url, params: VALID_QUESTION_PARAMS
    sign_out user

    patch question_url(Question.first.id), params: VALID_UPDATE_PARAMS

    assert_redirected_to new_user_session_path
    assert_equal 'You must be signed in to continue.', flash[:alert]
  end

  test "update action is not successful when not the author" do
    user_one = create_default_user
    user_two = create_random_user

    sign_in user_one
    post questions_url, params: VALID_QUESTION_PARAMS
    sign_out user_one

    sign_in user_two
    patch question_url(Question.first.id), params: VALID_UPDATE_PARAMS

    assert_redirected_to root_path
    assert_equal 'You must be the author of a question to edit or delete.', flash[:alert]
  end

  test "update action with invalid params is not successful" do
    user = create_default_user
    sign_in user

    post questions_url, params: VALID_QUESTION_PARAMS
    patch question_url(Question.first.id), params: INVALID_QUESTION_PARAMS

    assert_response :unprocessable_entity
    assert_template :edit
  end

  test "delete action is successful when the author" do
    user = create_default_user

    sign_in user
    post questions_url, params: VALID_QUESTION_PARAMS

    assert_difference('Question.count', -1) do
      delete question_url(Question.last.id)
    end

    assert_redirected_to questions_path
    assert_equal 'Question deleted successfully.', flash[:notice]
  end

  test "delete action is not successful when not the author" do
    user_one = create_default_user
    user_two = create_random_user

    sign_in user_one
    post questions_url, params: VALID_QUESTION_PARAMS
    sign_out user_one

    sign_in user_two

    assert_no_difference('Question.count') do
      delete question_url(Question.last.id)
    end

    assert_redirected_to root_path
    assert_equal 'You must be the author of a question to edit or delete.', flash[:alert]
  end

  test "delete action is not successful when not signed in" do
    user = create_default_user

    sign_in user
    post questions_url, params: VALID_QUESTION_PARAMS
    sign_out user

    assert_no_difference('Question.count') do
      delete question_url(Question.last.id)
    end

    assert_redirected_to new_user_session_path
    assert_equal 'You must be signed in to continue.', flash[:alert]
  end
end
