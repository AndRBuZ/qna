class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)
    return unless @questions.any?

    mail to: user.email
  end
end
