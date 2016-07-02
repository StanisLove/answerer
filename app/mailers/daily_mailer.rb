class DailyMailer < ApplicationMailer
  def digest(user)
		@questions = Question.during_last(30.days)
    mail to: user.email
  end
end
