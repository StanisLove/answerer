require 'rails_helper'

feature 'User browse questions', %q{
  In order to find needed question
  As an user
  I want to be able to browse questions
} do

  given(:questions) { create_list(:question, 2) }
  given(:user)      { create(:user) }
  
  scenario 'User try to browse questions' do
    questions.each do |q| 
      signed_in_user_create_question(user, q)
    end

    visit questions_path
    questions.each do |q|
      expect(page).to have_content(q.title)
      expect(page).to have_content(q.body)
    end
    expect(current_path).to eq questions_path
  end
end

