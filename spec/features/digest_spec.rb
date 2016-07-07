require 'features_helper'

feature 'User receive daily digest', %q{
  In order to watch out for new questions
  As an user
  I want to be able to receive daily digest
} do

  given!(:questions) { create_list :question, 2 }
  given(:user)       { create      :user      }

  before do
    clear_emails
    DailyMailer.digest(user).deliver_now
    open_email user.email
  end

  scenario 'User recieve email with questions' do
    questions.each do |question|
      expect(current_email).to have_content question.user.email
      expect(current_email).to have_link question.title
    end

    current_email.click_link questions.first.title
    expect(page).to have_current_path question_path(questions.first)
  end
end
