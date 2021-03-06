require 'features_helper'

feature 'User destroy question', '
  In order to delete unnecessary question
  As an author of question
  I want to be able to destroy question
' do

  given!(:question) { create(:question) }
  given(:other_user) { create(:user) }

  scenario 'Author of the question try to delete the question' do
    sign_in(question.user)
    visit questions_path
    click_on 'Delete Question'
    expect(page).not_to have_content(question.title)
    expect(page).not_to have_content(question.body)
    expect(current_path).to eq questions_path
  end

  scenario "User try to delete someone's question" do
    visit questions_path
    expect(page).to have_content(question.title)
    expect(page).not_to have_content('Delete Question')
    sign_in(other_user)
    visit questions_path
    expect(page).to have_content(question.title)
    expect(page).not_to have_content('Delete Question')
  end
end
