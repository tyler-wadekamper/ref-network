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
end
