class WeeklyQuestionEmailJob < ApplicationJob
  queue_as :default

  def perform
    questions = Question.top_upvoted_from_last_week
    users = User.all

    if questions.any?
      users.each do |user|
        WeeklyQuestionMailer.weekly_top_questions(questions, user).deliver_now
      end
    else
      users.each do |user|
        WeeklyQuestionMailer.reminder_email(user).deliver_now
      end
    end
  end
end
