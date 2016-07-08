require 'features_helper'

feature 'User searches documents', %q{
  In order to find neccessary information
  As an guest
  I want to be able to search documents
} do
  given!(:user)     { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer)   { create :answer,   user: user }
  given!(:comment)  { create :comment,  commentable: question, user: user }

  scenario 'Guest try to find User' do
    search(query: user.email, model: 'Users')

    expect(page).to     have_content "User #{user.email} registered at"
    expect(page).to_not have_content "asked"
    expect(page).to_not have_content "answered"
    expect(page).to_not have_content "commented"
  end

  scenario 'Guest try to find Question' do
    search(query: user.email, model: 'Questions')

    expect(page).to     have_content "User #{user.email} asked"
    expect(page).to_not have_content "registered at"
    expect(page).to_not have_content "answered"
    expect(page).to_not have_content "commented"
  end

  scenario 'Guest try to find Answer' do
    search(query: user.email, model: 'Answers')

    expect(page).to     have_content "User #{user.email} answered"
    expect(page).to_not have_content "asked"
    expect(page).to_not have_content "registered at"
    expect(page).to_not have_content "commented"
  end

  scenario 'Guest try to find Comments' do
    search(query: user.email, model: 'Comments')

    expect(page).to     have_content "User #{user.email} commented"
    expect(page).to_not have_content "asked"
    expect(page).to_not have_content "answered"
    expect(page).to_not have_content "registered at"
  end

  scenario 'Guest try to find Anywhere' do
    search(query: user.email, model: 'Anywehere')

    expect(page).to  have_content "User #{user.email} registered at"
    expect(page).to  have_content "User #{user.email} asked"
    expect(page).to  have_content "User #{user.email} answered"
    expect(page).to  have_content "User #{user.email} commented"
  end
end
