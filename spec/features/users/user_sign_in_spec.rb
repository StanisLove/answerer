require 'features_helper'

feature 'User sign in', %q{
  In order to be able to create questions and answers
  As an user
  I want to be able to sign in
} do

  given(:user)       { create :user }
  given(:unreg_user) { build  :user }

  scenario 'Registered user try to sign in' do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Unregistered user try to sign in' do
    sign_in(unreg_user)
    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Signed in user try to sign in' do
    sign_in(user)
    visit new_user_session_path
    expect(page).to have_content 'You are already signed in.'
    expect(current_path).to eq root_path
  end

  scenario 'User try to sign in with Facebook account' do
    visit new_user_session_path
    expect(page).to have_content 'Sign in with Facebook'

    mock_auth_facebook_hash
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to have_content 'Sign Out'
  end

  scenario 'User try to sign in with Twitter account' do
    visit new_user_session_path
    expect(page).to have_content 'Sign in with Twitter'

    mock_auth_twitter_hash
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Sign In'
    expect(page).to have_content 'Please confirm your email address. No spam.'

    fill_in 'Email', with: 'really@email.com'
    click_on 'Continue'

    open_email('really@email.com')
    expect(current_email).to have_content "Click the following link to activate your account. Confirm email"
    current_email.click_link 'Confirm email'
    expect(page).to have_content 'Email successfully confirmed.'
    expect(page).to have_content 'Sign Out'

    click_on 'Sign Out'
    expect(page).to have_content 'Signed out successfully.'
    click_on 'Sign In'
    click_on 'Sign in with Twitter'
    expect(page).to have_content 'Successfully authenticated from Twitter account.'
  end

  scenario 'User try to sign in with Twitter account and enter invalid email' do
    visit new_user_session_path
    expect(page).to have_content 'Sign in with Twitter'

    mock_auth_twitter_hash
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Sign In'
    expect(page).to have_content 'Please confirm your email address. No spam.'

    fill_in 'Email', with: 'invalid'
    click_on 'Continue'

    expect(page).to have_content 'Authorization error.'
  end

  scenario 'User try to sign in with invalid Facebook credentials' do
    visit new_user_session_path

    invalid_credentials
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Could not authenticate you from Facebook'
  end
end

