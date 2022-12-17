require "test_helper"

class AnswerTest < ActiveSupport::TestCase
  # answer save is tested in question_test.rb through nested attributes

  def build_answer(build_hash)
    user = build(:default_user)
    answer = build(:answer, build_hash)
    build(:question, author: user, answer:)
    answer
  end

  VALID_TEAMS = %w[A B]
  VALID_DOWNS = %w[1 2 3 4 FK]
  VALID_DISTANCE = ('1'..'99').to_a.append("G")
  VALID_YARDLINE_NUM = ('1'..'50').to_a
  VALID_CLOCK_STATUS = ['Ready', 'Snap', 'Running', 'On legal touch', 'Untimed']

  # team must be present and valid
  VALID_TEAMS.each do |team|
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
  VALID_DOWNS.each do |down|
    test "is valid when given #{down} as down" do
      answer = build_answer(down:)
      assert answer.valid?
    end
  end

  INVALID_DOWNS = ["Punt", "A", "5", 0, "Kick"]

  INVALID_DOWNS.each do |down|
    test "is not valid with #{down} as down" do
      answer = build_answer(down:)
      assert_not answer.valid?
    end
  end

  test "is not valid without a down" do
    EMPTY_VALUES.each do |value|
      answer = build_answer(down: value)
      assert_not answer.valid?
    end
  end

  # distance must be valid
  VALID_DISTANCE.each do |distance|
    test "is valid when given #{distance} as distance" do
      answer = build_answer(distance:)
      assert answer.valid?
    end
  end

  INVALID_DISTANCE = [104, -1, "Nine", "Goal"]

  INVALID_DISTANCE.each do |distance|
    test "is not valid with #{distance} as distance" do
      answer = build_answer(distance:)
      assert_not answer.valid?
    end
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
