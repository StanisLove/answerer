require 'features_helper'

feature 'The author of question is notified when a new answer appears', %q{
  In order to watch out for new answers
  As an author of question
  I want to be able to receive notifications by email
} do

  given!(:question)   { create :question }
  given!(:answer)     { create :answer, question: question }

  before do
    clear_emails
    NewAnswerMailer.notification(question.subscribers.first, answer).deliver_now
    open_email question.user.email
  end

  scenario 'The author of question receive notification' do
    expect(current_email.header('To')).to eq question.user.email
    expect(current_email).to have_content question.title
    expect(current_email).to have_content answer.user.email
    expect(current_email).to have_content answer.body

    current_email.click_link 'Open question'
    expect(page).to have_current_path question_path(question)
  end
end
