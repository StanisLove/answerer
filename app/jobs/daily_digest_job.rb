class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    questions = Question.yesterday
    if questions.present?
      User.find_each { |user| DailyMailer.digest(user, questions).deliver_later }
    end
  end
end
