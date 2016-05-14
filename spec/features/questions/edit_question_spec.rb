require 'features_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of the question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:other_question) { create(:question) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)
    expect(page).to_not have_content 'Редактировать'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'try to edit his answer', js: true do
      within '.question' do
        expect(page).to have_content('Редактировать')
        expect(page).to_not have_selector 'textarea'
        click_on 'Редактировать'
        expect(page).to have_selector 'textarea'
        expect(page).to_not have_content('Редактировать')

        fill_in 'Заголовок', with: 'new title'
        fill_in 'Вопрос',    with: 'new body'
        click_on 'Сохранить'
        wait_for_ajax
        expect(find('.question-content h3').text).to eq 'new title'
        expect(find('.question-content p').text).to eq 'new body'
        expect(page).to_not have_selector 'textarea'
        expect(find_link('Редактировать').visible?).to eq true
      end
    end

    scenario 'try to update answer with invalid content', js: true do
      within ".question" do
        click_on 'Редактировать'
        fill_in 'Заголовок',  with: ''
        fill_in 'Вопрос',     with: 'something'
        click_on 'Сохранить'
        expect(page).to have_content("Title can't be blank")

        click_on 'Редактировать'
        fill_in 'Заголовок',  with: 'something'
        fill_in 'Вопрос',     with: ''
        click_on 'Сохранить'
        expect(page).to have_content("Body can't be blank")

        click_on 'Редактировать'
        fill_in 'Заголовок',  with: 'something'
        fill_in 'Вопрос',     with: 'something'
        click_on 'Сохранить'
        expect(page).to_not have_content("Title can't be blank")
        expect(page).to_not have_content("Body can't be blank")
      end
    end

    scenario "try to edit someone's answer" do
      visit question_path(other_question)
      within '.question' do
        expect(page).to_not have_content 'Редактировать'
      end
    end
  end
end
