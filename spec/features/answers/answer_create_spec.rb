require 'rails_helper'

feature 'User creates answer', %q{
  In order to help to solve the problem
  As an user
  I want to be able to create answer
} do

  given!(:question) { create(:question) }
  given(:answer)    { build(:answer) }
  given(:other_user){ create(:user) }

  scenario 'Authenticated user try to create answer' do
    sign_in(other_user)
    visit questions_path
    within(:css, "div.question-#{question.id}") do
      click_on 'Написать ответ'
    end
    fill_in 'Ответ',  with: answer.body
    click_on 'Отправить ответ'
    expect(page).to have_content('Ответ успешно создан')
    expect(page).to have_content("#{question.title}")
    expect(page).to have_content("#{question.body}")
    expect(page).to have_content("#{answer.body}")
  end
end
