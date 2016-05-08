require 'rails_helper'

feature 'User browse question and answers', %q{
  In order to find correct answer
  As an user
  I want to be able to browse answers the question
} do

  given!(:question) { create(:question) }
  given!(:answers)  { create_list(:answer, 2) }   
  given(:user)      { create(:user) }

  scenario 'User try to browse answers the question' do
    visit question_answers_path(question)
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    answers.each do |a|
      expect(page).to have_content(a.body)
    end
    expect(current_path).to eq question_answers_path(question)
  end
end
