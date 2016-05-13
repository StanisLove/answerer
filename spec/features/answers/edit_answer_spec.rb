require 'features_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of the answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:other_answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)
    expect(page).to_not have_content('Редактировать')
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'user sees link to Edit' do
      within '.answers' do
        expect(page).to have_content('Редактировать ответ')
      end
    end

    scenario 'try to edit his answer', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Редактировать ответ'
        fill_in 'Ответ', with: 'edited answer'
        find('input[type="submit"]').click
        expect(page).to have_content('edited answer')
        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
        expect(find_link('Редактировать ответ').visible?).to eq true

        click_on 'Редактировать ответ'
        fill_in 'Ответ', with: 'edit again'
      end
    end
    
  end

  scenario "User try to edit someone's answer" do
    sign_in(other_user)
    visit question_path(question)
    expect(page).not_to have_content('Редактировать ответ')
  end
end
