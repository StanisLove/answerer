require 'rails_helper'

feature 'User destroy question', %q{
  In order to delete unnecessary question
  As an author of question
  I want to be able to destroy question
} do

  given(:user)      { create(:user) }
  given(:question)  { create(:question) }
  given(:other_user){ create(:user) }

  scenario 'Author of the question try to delete the question' do
    signed_in_user_create_question(user, question)
    sign_in(user)
    visit questions_path
    within(:css, "div.question-#{question.id}") do
      click_on "Удалить вопрос"
    end
    expect(page).to_not have_content(question.title)
    expect(page).to_not have_content(question.body)
    expect(current_page).to eq questions_path
  end

#  scenario "User try to delete someone's question" do
#    signed_in_user_create_question(user, question)
#    sign_in(other_user)
#    page.driver.submit :delete, question_path(question), {}
#    expect(page).to have_content('Ошибка доступа')
#    expect(current_path).to eq root_path
#  end
  scenario 'User try to delete a non-existent question'
  scenario 'Unregistered user try to delete the question'
end
