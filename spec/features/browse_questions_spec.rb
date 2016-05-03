require 'rails_helper'

feature 'User browse questions', %q{
  In order to find needed question
  As an user
  I want to be able to browse questions
} do

  given(:questions) { create_list(:question, 2) }
  
  scenario 'User try to browse questions' do
    questions.each do |q|
      visit new_question_path
      fill_in 'Заголовок',  with: q.title
      fill_in 'Вопрос',     with: q.body
      click_on 'Спросить'
    end

    visit questions_path
    questions.each do |q|
      expect(page).to have_content(q.title)
      expect(page).to have_content(q.body)
    end
    expect(current_path).to eq questions_path
  end
end

