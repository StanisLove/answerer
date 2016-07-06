require 'features_helper'

feature "The user can subscribe to new questions's answers", %q{
  In order to watch out for new answers
  As an user
  I want to be able to subscribe to question's answers
} do

  given!(:question) { create :question }
  given(:user)      { create :user }

  scenario 'Signed in user subscribes to question', js: true do
    sign_in user
    visit question_path(question)

    expect(page).to     have_content 'Subscribe'
    expect(page).to_not have_content 'Unsubscribe'

    click_on 'Subscribe'
    expect(page).to_not have_content 'Subscribe'
    expect(page).to     have_content 'Unsubscribe'
    expect(question.subscribers).to include user

    click_on 'Unsubscribe'
    expect(page).to     have_content 'Subscribe'
    expect(page).to_not have_content 'Unsubscribe'
    expect(question.subscribers).to_not include user
  end

  scenario 'Guest can not subscribe' do
    visit question_path(question)

    expect(page).to_not have_content 'Subscribe'
    expect(page).to_not have_content 'Unsubscribe'
  end
end
