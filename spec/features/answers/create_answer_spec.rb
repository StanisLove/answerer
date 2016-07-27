require 'features_helper'

feature 'User creates answer', '
  In order to help to solve the problem
  As an user
  I want to be able to create answer
' do

  given!(:question) { create :question }
  given(:answer)    { build  :answer }
  given(:user)      { create :user }

  scenario 'Authenticated user try to create answer', js: true do
    sign_in user
    visit question_path(question)
    fill_in  'New Answer', with: answer.body
    click_on 'Publish Answer'
    expect(page).to have_content 'Answer was successfully created.'
    expect(page).to have_content question.title.to_s
    expect(page).to have_content question.body.to_s
    within ".answers" do
      expect(page).to have_content answer.body.to_s
      expect(page).to have_link    "Delete Answer"
      expect(page).to have_link    "Edit Answer"
    end
    within '.new_answer' do
      expect(page).not_to have_content answer.body.to_s
    end
  end

  scenario 'User try to create invalid answer', :js do
    sign_in user
    visit question_path(question)
    click_on 'Publish Answer'
    expect(page).to have_content "Body can't be blank"

    fill_in  'New Answer', with: answer.body
    click_on 'Publish Answer'
    expect(page).not_to have_content "Body can't be blank"
  end

  context "multiple sessions", :js do
    scenario "all users see new answer in real-time" do
      Capybara.using_session "author" do
        sign_in user
        visit question_path(question)
      end

      Capybara.using_session "guest" do
        visit question_path(question)
      end

      Capybara.using_session "author" do
        fill_in  'New Answer', with: answer.body
        click_on 'Publish Answer'
        wait_for_ajax
        expect(page).to have_content 'Answer was successfully created.'
        within ".answers" do
          expect(page).to have_content answer.body.to_s
          expect(page).to have_link    "Delete Answer"
          expect(page).to have_link    "Edit Answer"
        end
        within '.new_answer' do
          expect(page).not_to have_content answer.body.to_s
        end
      end

      Capybara.using_session "guest" do
        wait_for_ajax
        expect(page).not_to have_content 'Answer was successfully created.'
        expect(page).to     have_content answer.body.to_s
        expect(page).not_to have_link    "Delete Answer"
        expect(page).not_to have_link    "Edit Answer"
      end
    end
  end
end
