require 'rails_helper'

feature 'User creates answer', %q{
  In order to help to solve the problem
  As an user
  I want to be able to create answer
} do

  given(:question)  { create(:question) }
  given(:answer)    { create(:answer) }

  scenario 'User try to create answer' do
    create_question(question)

    visit questions_path
    page.find("a.question-#{question.id}").click
    fill_in 'Ответ',  with: answer.body
    click_on 'Отправить ответ'
    expect(page).to have_content('Ответ успешно создан')
    expect(page).to have_content("#{question.title}")
    expect(page).to have_content("#{question.body}")
    expect(page).to have_content("#{answer.body}")
  end
end
