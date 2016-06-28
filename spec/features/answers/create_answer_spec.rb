require 'features_helper'

feature 'User creates answer', %q{
  In order to help to solve the problem
  As an user
  I want to be able to create answer
} do

  given!(:question)  { create :question }
  given(:answer)     { build  :answer }
  given(:other_user) { create :user }

  scenario 'Authenticated user try to create answer', js: true do
    sign_in(other_user)
    visit question_path(question)
    fill_in  'New Answer',  with: answer.body
    click_on 'Publish Answer'
    expect(page).to have_content 'Answer was successfully created.'
    expect(page).to have_content "#{question.title}"
    expect(page).to have_content "#{question.body}"
    expect(page).to have_content "#{answer.body}"
    within '.new_answer' do
      expect(page).to_not have_content "#{answer.body}"
    end
  end

  scenario 'User try to create invalid answer', js: true do
    sign_in(other_user)
    visit question_path(question)
    click_on 'Publish Answer'
    expect(page).to have_content "Body can't be blank"

    fill_in  'New Answer', with: answer.body
    click_on 'Publish Answer'
    expect(page).to_not have_content "Body can't be blank"
  end
end
