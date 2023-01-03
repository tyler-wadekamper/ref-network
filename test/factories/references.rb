FactoryBot.define do
  factory :default_reference, class: Reference do
    rule { "3" }
    section { "3" }
    article { "2" }
    subarticle { "d" }
    name { "Starts on the Snap" }
  end

  factory :random_reference, class: Reference do
    rule { %w[1..12].sample }
    section { %w[1..5].sample }
    article { %w[1..5].sample }
    subarticle { %w[a..j].sample }
    name { Faker::Lorem.sentence }
  end
end
