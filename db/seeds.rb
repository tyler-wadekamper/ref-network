require 'csv'
require 'faker'

def seed_questions
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

    question = Question.new

    answer = question.build_answer(team:,
                                   down:,
                                   distance:,
                                   yardline_team:,
                                   yardline_num:,
                                   clock_status:,
                                   explanation:)

    Question.create!(author: User.where(email: "tyler.wadekamper@gmail.com"),
                     body:,
                     answer:)
  end
end

seed_questions