class DailyMailer < ApplicationMailer
  def digest(user)
		@questions = Question.during_last(24.hours)
    mail to: user.email
  end
end
