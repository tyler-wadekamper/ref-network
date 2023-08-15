class WeeklyQuestionMailer < ApplicationMailer
  def weekly_top_questions(questions, user)
    @questions = questions
    @user = user
    mail(to: @user.email, subject: 'Questions of the Week') do |format|
      format.html
    end
  end

  def reminder_email(user)
    @user = user
    mail(to: @user.email, subject: 'Have you gotten better today?') do |format|
      format.html
    end
  end
end
