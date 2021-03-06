require 'features_helper'

feature 'User destroys answer', '
In order to delete unnecessary answer
As an author of question
I want to be able to destroy answer
' do

  given!(:question)  { create(:question) }
  given!(:answer)    { create(:answer, question: question) }
  given(:other_user) { create(:user) }

  scenario 'Author of the answer try to delete the answer', js: true do
    sign_in(answer.user)
    visit question_path(question)
    expect(page).to have_content answer.body
    expect(page).to have_content 'Delete Answer'
    click_on 'Delete Answer'
    wait_for_ajax

    expect(page).not_to have_content(answer.body)
    expect(page).not_to have_css "#answer-#{answer.id}"
  end

  scenario "User try to delete someone's question" do
    visit question_path(question)
    expect(page).not_to have_content('Delete Answer')

    sign_in(other_user)
    visit question_path(question)
    expect(page).not_to have_content('Delete Answer')
  end
end
