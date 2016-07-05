require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:question) { create :question }
  let(:user)     { create :user }

  before { create :subscription, user: user, question: question }

  context "new answer created" do
    let(:answer)   { create :answer, question: question }

    it 'should send notifications to subscribers' do
      expect(NewAnswerMailer).to receive(:notification).
                                 with(question.user, answer).
                                 and_call_original
      expect(NewAnswerMailer).to receive(:notification).
                                 with(user, answer).
                                 and_call_original
      NewAnswerNotificationJob.perform_now(answer)
    end
  end

  context "new answer was not created" do
    it 'should not send notifications to subscribers' do
      expect(NewAnswerMailer).to_not receive :notification
      NewAnswerNotificationJob.perform_now(nil)
    end
  end
end
