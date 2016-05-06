require 'rails_helper'

feature 'User destroy question', %q{
  In order to delete unnecessary question
  As an author of question
  I want to be able to destroy question
} do

  given(:user)      { create(:user) }
  given(:question)  { build(:question) }
  given(:other_user){ create(:user) }

  scenario 'Author of the question try to delete the question' do
    signed_in_user_create_question(user, question)
    sign_in(user)
    visit questions_path
    click_on 'Удалить вопрос'
    expect(page).to_not have_content(question.title)
    expect(page).to_not have_content(question.body)
    expect(current_path).to eq questions_path
  end

  scenario "User try to delete someone's question" do
    signed_in_user_create_question(user, question)
    visit questions_path
    expect(page).to have_content(question.title)
    expect(page).to_not have_content('Удалить вопрос')
    sign_in(other_user)
    visit questions_path
    expect(page).to have_content(question.title)
    expect(page).to_not have_content('Удалить вопрос')
  end
end
