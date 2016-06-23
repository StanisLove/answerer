require 'features_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of the question
  I'd like to be able to edit my question
} do

  given!(:question)       { create(:question) }
  given!(:other_question) { create(:question) }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)
    expect(page).to_not have_content 'Edit Question'
  end

  describe 'Authenticated user' do
    before do
      sign_in(question.user)
      visit question_path(question)
    end

    scenario 'try to edit his answer', js: true do
      within '.question' do
        expect(page).to have_content('Edit Question')
        expect(page).to_not have_selector 'textarea'
        click_on 'Edit Question'
        expect(page).to have_selector 'textarea'
        expect(page).to_not have_content('Edit Question')

        fill_in 'Title', with: 'new title'
        fill_in 'Question',    with: 'new body'
        click_on 'Save Question'
        wait_for_ajax
        expect(find('.question-content h3').text).to eq 'new title'
        expect(find('.question-content p').text).to eq 'new body'
        expect(page).to_not have_selector 'textarea'
        expect(find_link('Edit Question').visible?).to eq true
      end
    end

    scenario 'try to update answer with invalid content', js: true do
      within ".question" do
        click_on 'Edit Question'
        fill_in 'Title',  with: ''
        fill_in 'Question',     with: 'something'
        click_on 'Save Question'
        expect(page).to have_content("Title can't be blank")

        click_on 'Edit Question'
        fill_in 'Title',  with: 'something'
        fill_in 'Question',     with: ''
        click_on 'Save Question'
        expect(page).to have_content("Question can't be blank")

        click_on 'Edit Question'
        fill_in 'Title',  with: 'something'
        fill_in 'Question',     with: 'something'
        click_on 'Save Question'
        expect(page).to_not have_content("Title can't be blank")
        expect(page).to_not have_content("Question can't be blank")
      end
    end

    scenario "try to edit someone's answer" do
      visit question_path(other_question)
      within '.question' do
        expect(page).to_not have_content 'Edit Question'
      end
    end
  end
end
