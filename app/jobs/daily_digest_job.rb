class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    if Question.during_last(24.hours).exists?
      User.find_each { |user| DailyMailer.digest(user).deliver_later }
    end
  end
end
