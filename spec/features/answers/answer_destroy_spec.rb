require 'rails_helper'

feature 'User destroys answer', %q{
In order to delete unnecessary answer
As an author of question
I want to be able to destroy answer
} do

  given!(:question) { create(:question) }
  given!(:answer)   { create(:answer) }
  given(:other_user){ create(:user) }

  scenario 'Author of the answer try to delete the answer' do
    sign_in(answer.user)
    visit question_answers_path(question)
    expect(page).to have_content(answer.body)
    expect(page).to have_content('Удалить ответ')
    click_on 'Удалить ответ'
    expect(page).to_not have_content(answer.body)
  end

  scenario "User try to delete someone's question" do
    visit question_answers_path(question)
    expect(page).to_not have_content('Удалить ответ')
    sign_in(other_user)
    visit question_answers_path(question)
    expect(page).to_not have_content('Удалить ответ')
  end
end
