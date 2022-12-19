require "test_helper"

class AnswerTest < ActiveSupport::TestCase
  # answer save is tested in question_test.rb through nested attributes

  def build_answer(build_hash)
    user = build_default_user
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

  INVALID_TEAMS = ["Team A", "Z", "Offense", "Receivers", 4]

  INVALID_TEAMS.each do |team|
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

  INVALID_DISTANCE = [104, -1, 0, "Nine", "Goal"]

  INVALID_DISTANCE.each do |distance|
    test "is not valid with #{distance} as distance" do
      answer = build_answer(distance:)
      assert_not answer.valid?
    end
  end

  # yardline team must be present and valid
  VALID_TEAMS.each do |team|
    test "is valid when given #{team} as yardline team" do
      answer = build_answer(yardline_team: team)
      assert answer.valid?
    end
  end

  INVALID_TEAMS.each do |team|
    test "is not valid with #{team} as yardline team" do
      answer = build_answer(yardline_team: team)
      assert_not answer.valid?
    end
  end

  test "is not valid without a yardline team" do
    EMPTY_VALUES.each do |value|
      answer = build_answer(yardline_team: value)
      assert_not answer.valid?
    end
  end

  INVALID_YARDLINE_NUM = [0, "51", -1, "Forty"]

  # yardline number must be present and valid
  VALID_YARDLINE_NUM.each do |num|
    test "is valid when given #{num} as yardline number" do
      answer = build_answer(yardline_num: num)
      assert answer.valid?
    end
  end

  INVALID_YARDLINE_NUM.each do |num|
    test "is not valid with #{num} as yardline number" do
      answer = build_answer(yardline_num: num)
      assert_not answer.valid?
    end
  end

  test "is not valid without a yardline number" do
    EMPTY_VALUES.each do |value|
      answer = build_answer(yardline_num: value)
      assert_not answer.valid?
    end
  end
  
  # clock status must be valid
  VALID_CLOCK_STATUS.each do |status|
    test "is valid when given #{status} as clock status" do
      answer = build_answer(clock_status: status)
      assert answer.valid?
    end
  end

  INVALID_CLOCK_STATUS = ["Stopped", "Hot", 0, "untimed"]

  INVALID_CLOCK_STATUS.each do |status|
    test "is not valid with #{status} as clock status" do
      answer = build_answer(clock_status: status)
      assert_not answer.valid?
    end
  end
end
