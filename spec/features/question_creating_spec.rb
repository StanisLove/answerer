require 'rails_helper'

feature 'User creates question', %q{
  In order to solve the problem
  As an user
  I want to be able to create question
} do

  given(:question) { create(:question) }

  scenario 'User try to create question' do
    create_question(question)
    expect(page).to have_content('Вопрос успешно создан')
  end
end
