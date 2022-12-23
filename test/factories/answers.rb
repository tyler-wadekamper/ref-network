FactoryBot.define do
  factory :answer do
    team { "A" }
    down { "2" }
    distance { "9" }
    yardline_team { "B" }
    yardline_num { "34" }
    clock_status { "Ready" }
    explanation { "This is the explanation for the test answer." }
  end

  factory :random_answer, class: Answer do
    team { Answer::VALID_TEAMS.sample }
    down { Answer::VALID_DOWNS.sample }
    distance { Answer::VALID_DISTANCE.sample }
    yardline_team { Answer::VALID_TEAMS.sample }
    yardline_num { Answer::VALID_YARDLINE_NUM.sample }
    clock_status { Answer::VALID_CLOCK_STATUS.sample }
    explanation { Faker::Lorem.paragraph }
  end
end
