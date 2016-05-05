require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to create questions and answers
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) }
  given(:unreg_user) { build(:user) }

  scenario 'Registered user try to sign in' do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Unregistered user try to sign in' do
    sign_in(unreg_user)
    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end
end

