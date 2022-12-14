require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "saves when all fields are provided" do
    user = build(:default_user)
    assert user.save
  end

  test "does not save without first name" do
    user = build(:default_user, first_name: "")
    assert_not user.save
  end

  test "does not save without last name" do
    user = build(:default_user, last_name: "")
    assert_not user.save
  end

  test "does not save without email" do
    user = build(:default_user, email: "")
    assert_not user.save
  end

  test "capitalizes names before save" do
    user = build(:default_user, first_name: "bill", last_name: "jenkins")
    user.save
    assert_equal user.first_name, "Bill"
    assert_equal user.last_name, "Jenkins"
  end

  test "#questions returns collection of authored questions" do
    user = create(:default_user)
    authored_questions = create_list(:question, 3, author: user)
    assert_equal user.questions, authored_questions
  end
end
