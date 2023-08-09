class WeeklyQuestionMailer < ApplicationMailer
  def weekly_top_questions(questions, user)
    @questions = questions
    @user = user
    mail(to: @user.email, subject: 'Top Questions of the Week')
  end

  def reminder_email(user)
    @user = user
    mail(to: @user.email, subject: 'Reminder to Post New Questions')
  end
end
