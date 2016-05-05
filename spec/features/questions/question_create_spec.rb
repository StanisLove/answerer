require 'rails_helper'

feature 'User creates question', %q{
  In order to solve the problem
  As an user
  I want to be able to create question
} do

  given(:question)  { create(:question) }
  given(:user)      { create(:user) }

  scenario %q{
    Authenticated user 
    try to create question
  } do
    sign_in(user)
    create_question(question)
    expect(page).to have_content('Вопрос успешно создан')
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
end
