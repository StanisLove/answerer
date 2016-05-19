require 'features_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of the answer
  I'd like to be able to edit my answer
} do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:other_answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)
    expect(page).to_not have_content('Редактировать')
  end

  describe 'Authenticated user' do
    before do
      sign_in(answer.user)
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within '.answers' do
        expect(page).to have_content('Редактировать ответ')
      end
    end

    scenario 'try to edit his answer', js: true do
      within "#answer-#{answer.id}" do
        expect(page).to_not have_selector 'textarea'
        click_on 'Редактировать ответ'
        expect(page).to have_selector 'textarea'

        fill_in 'Ответ', with: 'edited answer'
        click_on 'Сохранить'

        expect(page).to have_content('edited answer')
        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
        expect(find_link('Редактировать ответ').visible?).to eq true

        click_on 'Редактировать ответ'
        fill_in 'Ответ', with: 'edit again'
      end
    end

    scenario 'try to update answer with invalid content', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Редактировать ответ'
        fill_in 'Ответ', with: ''
        click_on 'Сохранить'
        expect(page).to have_content("Body can't be blank")

        click_on 'Редактировать ответ'
        fill_in 'Ответ', with: 'some content'
        click_on 'Сохранить'
        expect(page).to_not have_content("Body can't be blank")
      end
    end

    scenario "try to edit someone's answer" do
      within "#answer-#{other_answer.id}" do
        expect(page).not_to have_content('Редактировать ответ')
      end
    end
  end
end
