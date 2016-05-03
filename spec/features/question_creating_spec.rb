require 'rails_helper'

feature 'User creates question', %q{
  In order to solve the problem
  As an user
  I want to be able to create question
} do

  given(:question) { create(:question) }
  given(:new_question) { Question.find(question.id + 1) }

  scenario 'User try to create question' do
    visit new_question_path
    fill_in 'Заголовок',  with: question.title
    fill_in 'Вопрос',     with: question.body
    click_on 'Спросить'

    expect(page).to have_content('Вопрос успешно создан')
    expect(current_path).to eq question_path(new_question)
  end
end
