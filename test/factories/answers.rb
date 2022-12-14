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
end
