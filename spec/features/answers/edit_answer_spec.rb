require 'features_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of the answer
  I'd like to be able to edit my answer
} do

  given!(:question)     { create :question }
  given!(:answer)       { create :answer, question: question }
  given!(:other_answer) { create :answer, question: question }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Edit Answer'
  end

  describe 'Authenticated user' do
    before do
      sign_in(answer.user)
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within '.answers' do
        expect(page).to have_content 'Edit Answer'
      end
    end

    scenario 'try to edit his answer', js: true do
      within "#answer-#{answer.id}" do
        expect(page).to_not have_selector 'textarea'
        click_on 'Edit Answer'
        expect(page).to     have_selector 'textarea'

        fill_in  'Answer', with: 'edited answer'
        click_on 'Save Answer'

        expect(page).to     have_content  'edited answer'
        expect(page).to_not have_content  answer.body
        expect(page).to_not have_selector 'textarea'
        expect(find_link('Edit Answer').visible?).to eq true

        click_on 'Edit Answer'
        fill_in  'Answer', with: 'edit again'
      end
    end

    scenario 'try to update answer with invalid content', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Edit Answer'
        fill_in  'Answer', with: ''
        click_on 'Save Answer'
        expect(page).to have_content "Body can't be blank"

        click_on 'Edit Answer'
        fill_in  'Answer', with: 'some content'
        click_on 'Save Answer'
        expect(page).to_not have_content "Body can't be blank"
      end
    end

    scenario "try to edit someone's answer" do
      within "#answer-#{other_answer.id}" do
        expect(page).not_to have_content 'Edit Answer'
      end
    end
  end
end
