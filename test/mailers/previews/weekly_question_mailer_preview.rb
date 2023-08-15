# Preview all emails at http://localhost:3000/rails/mailers/weekly_question_mailer
class WeeklyQuestionMailerPreview < ActionMailer::Preview
  def weekly_top_questions
    user = User.first
    questions = Question.top_upvoted_from_last_week
    WeeklyQuestionMailer.weekly_top_questions(questions, user)
  end

  def reminder_email
    user = User.first
    WeeklyQuestionMailer.reminder_email(user)
  end
end
