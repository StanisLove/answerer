require 'rails_helper'

feature 'User sign out', %q{
  In order to be able to protect the account
  As an user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Signed in user try to sign out' do
    sign_in(user)
    click_on 'Выйти'
    expect(page).to have_content('Signed out successfully.')
    expect(page).to have_content('Войти')
  end
end
