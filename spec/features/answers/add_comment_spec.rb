require 'features_helper'

feature 'User adds comment to the answer', %{
  In order to discuss the answer
  As an user
  I'd like to be able to comment the answer
} do

  given(:question) { create :question }
  given!(:answer)  { create :answer, question: question }
  given(:user)     { create :user }
  given(:comment)  { build :comment, commentable: answer }

  scenario "User leaves a comment to the answer", js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Add Comment'

    sign_in(user)
    visit question_path(question)
    visit_server
    within "#answer-#{answer.id}" do
      expect(page).to     have_content 'Add Comment'
      expect(page).to_not have_selector('.answers .new_comment', visible: true)
      click_on 'Add Comment'
      expect(page).to     have_selector('.answers .new_comment', visible: true)

      fill_in  'Comment', with: comment.body
      click_on 'Add Comment'
      expect(page).to     have_content user.email
      expect(page).to     have_content comment.body
      expect(page).to     have_content 'Add Comment'
      expect(page).to_not have_selector('.answers .new_comment', visible: true)
    end
  end

  scenario 'User try to leave invalid comment', js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{answer.id}" do
      click_on 'Add Comment'
      fill_in  'Comment', with: ' '
      click_on 'Add Comment'
      expect(page).to have_content("Comment can't be blank")
    end
  end

  given!(:first_comment)  { create :comment, commentable: answer }
  given!(:second_comment) { create :comment, commentable: answer }

  scenario "User browse question's comments in right order", js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{answer.id}" do
      expect(find('.comments > div:first-child').text).to have_content first_comment.body
      expect(find('.comments > div:last-child').text).to have_content second_comment.body
    end
  end
end
