class WeeklyQuestionMailer < ApplicationMailer
  def weekly_top_questions(questions, user)
    attachments.inline['white_logo.png'] = File.read('app/assets/images/white_logo.png')
    @questions = questions
    @user = user
    mail(to: @user.email, subject: 'Questions of the Week') do |format|
      format.html
    end
  end

  def reminder_email(user)
    attachments.inline['white_logo.png'] = File.read('app/assets/images/white_logo.png')
    @user = user
    mail(to: @user.email, subject: 'Have you gotten better today?') do |format|
      format.html
    end
  end
end
