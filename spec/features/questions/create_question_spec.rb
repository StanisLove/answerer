require 'features_helper'

feature 'User creates question', %q{
  In order to solve the problem
  As an user
  I want to be able to create question
} do

  given(:question) { create(:question) }
  given(:user)      { create(:user) }

  scenario %q{
    Authenticated user
    try to create question
  } do
    sign_in(user)
    visit new_question_path
    fill_in 'Title',    with: question.title
    fill_in 'Question', with: question.body
    click_on 'Ask Question'
    expect(page).to have_content('Question was successfully created.')
  end

  scenario %q{
    Not authenticated user
    try to create question
  } do
    visit new_question_path
    expect(page).to have_content(%q{
      You need to sign in or sign up before continuing})
    expect(current_path).to eq new_user_session_path
  end

  context "multiple sessions", :js do
    scenario "all users see new questions in real-time" do
      Capybara.using_session "author" do
        sign_in user
        visit new_question_path
      end

      Capybara.using_session "guest" do
        visit questions_path
      end

      Capybara.using_session "author" do
        fill_in 'Title',    with: "Title from private_pub"
        fill_in 'Question', with: "Body from private_pub"
        click_on 'Ask Question'
      end

      Capybara.using_session "guest" do
        wait_for_ajax
        expect(page).to have_content "Title from private_pub"
        expect(page).to have_content "Body from private_pub"
      end
    end
  end
end
