require 'rails_helper'

feature 'User sign up', %q{
  In order to be able to sign in
  As an user
  I want to be able to sign up
} do

  given(:user)      { build(:user) }
  given(:reg_user)  { create(:user) }

  scenario 'Unregistered user try to sign up' do
    sign_up(user)
    expect(page).to have_content('You have signed up successfully.')
    expect(current_path).to eq root_path
  end

  scenario 'Registered user try to sign up' do
    sign_up(reg_user)
    expect(page).to have_content('Email has already been taken')
    expect(current_path).to eq user_registration_path
  end

  scenario 'Signed in user try to sign up' do
    sign_in(reg_user)
    visit new_user_registration_path
    expect(page).to have_content('You are already signed in')
    expect(current_path).to eq root_path
  end

  private
    def sign_up(user)
      visit new_user_registration_path
      fill_in 'Email',      with: user.email
      fill_in 'Password',   with: user.password
      fill_in 'Password confirmation',
        with: user.password_confirmation
      click_on 'Sign up'
    end
end
