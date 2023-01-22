require 'csv'
require 'faker'

def seed_questions(author: nil)
  current_path = File.dirname(__FILE__)
  file_path = File.join(current_path, 'seed_questions_cfo_west.csv')

  CSV.foreach(file_path, headers: true) do |row|
    body = row.field('body')
    team = row.field('team')
    down = row.field('down')
    distance = row.field('distance')
    yardline_team = row.field('yardline_team')
    yardline_num = row.field('yardline_num')
    clock_status = row.field('clock_status')
    explanation = row.field('explanation')
    references_text = row.field('references').gsub(/\s+/, '').split(',')

    question = Question.new

    answer = question.build_answer(team:,
                                   down:,
                                   distance:,
                                   yardline_team:,
                                   yardline_num:,
                                   clock_status:,
                                   explanation:)

    if author
      question = Question.create!(author:,
                       body:,
                       answer:)
    else
      question = Question.create!(author: User.all.sample,
                       body:,
                       answer:)
    end

    references_text.each do |reference|
      question.references << Reference.where("text = ?", reference)
    end
  end
end

def seed_users
  (15..30).each do |id|
    User.create!(
              id: id, 
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              password: "password", 
              password_confirmation: "password")
  end
end
