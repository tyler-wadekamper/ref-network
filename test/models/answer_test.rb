require "test_helper"

class AnswerTest < ActiveSupport::TestCase
  # answer save is tested in question_test.rb through nested attributes

  def build_answer(build_hash)
    user = build(:default_user)
    answer = build(:answer, build_hash)
    build(:question, author: user, answer:)
    answer
  end

  # team must be present and valid
  Answer::VALID_TEAMS.each do |team|
    test "is valid when given #{team} as team" do
      answer = build_answer(team:)
      assert answer.valid?
    end
  end

  invalid_teams = ["Team A", "Z", "Offense", "Receivers", 4]

  invalid_teams.each do |team|
    test "is not valid with #{team} as team" do
      answer = build_answer(team:)
      assert_not answer.valid?
    end
  end

  test "is not valid without a team" do
    EMPTY_VALUES.each do |value|
      answer = build_answer(team: value)
      assert_not answer.valid?
    end
  end

  # down must be present and valid
  Answer::VALID_DOWNS.each do |down|
    test "is valid when given #{down} as down" do
      answer = build_answer(down:)
      assert answer.valid?
    end
  end

  invalid_downs = ["Punt", "A", "5", 0, "Kick"]

  invalid_downs.each do |down|
    test "is not valid with #{down} as down" do
      answer = build_answer(down:)
      assert_not answer.valid?
    end
  end

  test "is not valid without a down" do

  end

  # distance must be valid
  test "is valid when given valid distance attributes" do

  end

  test "is not valid with invalid distance attributes" do

  end

  # yardline team must be present and valid
  test "is valid when given valid yardline team attributes" do

  end

  test "is not valid with invalid yardline team attributes" do

  end

  test "is not valid without a yardline team" do

  end

  # yardline number must be present and valid
  test "is valid when given valid yardline number attributes" do

  end

  test "is not valid with invalid yardline number attributes" do

  end

  test "is not valid without a yardline number" do

  end
  
  # clock status must be valid
  test "is valid when given valid clock status attributes" do

  end

  test "is not valid with invalid clock status attributes" do

  end
end
