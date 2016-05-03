require 'rails_helper'

feature 'User creates answer', %q{
  In order to help to solve the problem
  As an user
  I want to be able to create answer
} do

  given(:question)  { create(:question) }
  given(:answer)    { create(:answer) }
  given(:new_answer){ Answer.find(answer.id + 1) }

  scenario 'User try to create answer' do
    visit new_question_path
    fill_in 'Заголовок',  with: question.title
    fill_in 'Вопрос',     with: question.body
    click_on 'Спросить'

    visit questions_path
    page.find("a.question-#{question.id}").click
    fill_in 'Ответ',  with: answer.body
    click_on 'Отправить ответ'
    expect(page).to have_content('Ответ успешно создан')
    expect(page).to have_content("#{question.title}")
    expect(page).to have_content("#{question.body}")
    expect(page).to have_content("#{answer.body}")
    expect(current_path).to eq question_answer_path(question, new_answer)
  end
end
