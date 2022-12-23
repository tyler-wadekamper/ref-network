require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "saves when all fields are provided" do
    user = build_default_user
    assert user.save
  end

  test "is not valid without first name" do
    EMPTY_VALUES.each do |value|
      user = build(:default_user, first_name: value)
      assert_not user.valid?
    end
  end

  test "is not valid without last name" do
    EMPTY_VALUES.each do |value|
      user = build(:default_user, first_name: value)
      assert_not user.valid?
    end
  end

  test "is not valid without email" do
    EMPTY_VALUES.each do |value|
      user = build(:default_user, email: value)
      assert_not user.valid?
    end
  end

  test "capitalizes names before save" do
    user = build(:default_user, first_name: "bill", last_name: "jenkins")
    user.save
    assert_equal user.first_name, "Bill"
    assert_equal user.last_name, "Jenkins"
  end

  test "#questions returns collection of authored questions" do
    user = create_default_user
    answer = build(:answer)
    authored_questions = create_list(:question, 3, author: user, answer:)
    assert_equal user.questions, authored_questions
  end
end
