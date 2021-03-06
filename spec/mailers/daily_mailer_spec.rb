require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user)      { create :user }
    let(:questions) { create_list :question, 2 }
    let(:mail)      { described_class.digest(user, questions) }

    it "renders the headers" do
      expect(mail.subject).to eq "Fresh questions"
      expect(mail.to).to      eq [user.email]
      expect(mail.from).to    eq ["from@example.com"]
    end

    it "renders the body" do
      expect(mail.body.encoded).to match "Questions in the last day."
    end
  end
end
