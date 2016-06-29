require 'features_helper'

feature 'User adds comment to the question', %{
  In order to discuss the question
  As an user
  I'd like to be able to comment the question
} do

  given(:question) { create :question }
  given(:user)     { create :user }
  given(:comment)  { build  :comment, commentable: question }

  scenario "User leaves a comment to the question", js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Add Comment'

    sign_in(user)
    visit question_path(question)

    expect(page).to     have_content 'Add Comment'
    expect(page).to_not have_selector('.question > .new_comment', visible: true)
    click_on 'Add Comment'
    expect(page).to     have_selector('.question .new_comment', visible: true)

    fill_in  'Comment', with: comment.body
    click_on 'Add Comment'
    wait_for_ajax

    expect(page).to     have_content user.email
    expect(page).to     have_content comment.body
    expect(page).to     have_content 'Add Comment'
    expect(page).to_not have_selector('.question .new_comment', visible: true)
  end

  scenario 'User try to leave invalid comment', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Add Comment'
    fill_in  'Comment', with: ' '
    click_on 'Add Comment'
    expect(page).to have_content("Comment can't be blank")
  end

  given!(:first_comment)  { create :comment, commentable: question }
  given!(:second_comment) { create :comment, commentable: question }

  scenario "User browse question's comments in right order", js: true do
    sign_in(user)
    visit question_path(question)

    expect(find('.comments > div:first-child').text).to have_content first_comment.body
    expect(find('.comments > div:last-child').text).to have_content second_comment.body
  end
end
