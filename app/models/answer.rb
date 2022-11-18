class Answer < ApplicationRecord
  VALID_TEAMS = %w[A B]
  VALID_DOWNS = %w[1 2 3 4 FK]
  VALID_DISTANCE = ('1'..'99').to_a
  VALID_YARDLINE_NUM = ('1'..'50').to_a
  VALID_CLOCK_STATUS = ['Ready', 'Snap', 'Running', 'On legal touch', 'Untimed']

  belongs_to :question

  validates :team, inclusion: { in: VALID_TEAMS, message: "Team must be 'A' or 'B'" }
  validates :down, inclusion: { in: VALID_DOWNS, message: "The down must be a number between 1 and 4." }
  validates :distance, inclusion: { in: VALID_DISTANCE, message: "The distance must a number between 1 and 99.", allow_blank: true }
  validates :yardline_team, inclusion: { in: VALID_TEAMS, message: "Team must be 'A' or 'B'", allow_blank: true }
  validates :yardline_num, inclusion: { in: VALID_YARDLINE_NUM, message: "The yardline must be between 1 and 50." }
  validates :clock_status, inclusion: { in: VALID_CLOCK_STATUS, message: "The clock status must be 'Ready', 'Snap', 'Running', 'On legal touch', or 'Untimed'.", allow_blank: true }

  validates_presence_of :team, :down, :yardline_team, :yardline_num
end
