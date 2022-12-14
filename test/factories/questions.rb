require "test_helper"

FactoryBot.define do
  factory :question do
    body { 'A 1/10 B-35. This is a test question that corresponds to a test answer. This text is the question body.' }
    answer { build(:answer) }
  end
end
