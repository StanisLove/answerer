require 'features_helper'

feature 'User adds comment to the answer', %{
  In order to discuss the answer
  As an user
  I'd like to be able to comment the answer
} do

  given(:question) { create :question }
  given!(:answer) { create :answer, question: question }
  given(:user) { create :user }
  given(:comment) { build :comment, commentable: answer }

  scenario "User leaves a comment to the answer", js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Добавить комментарий'

    sign_in(user)
    visit question_path(question)

    within "#answer-#{answer.id}" do
      expect(page).to have_content 'Добавить комментарий'
      expect(page).to_not have_selector('.new_comment > .edit_answer', visible: true)
      click_on 'Добавить комментарий'
      expect(page).to have_selector('.new_comment > .edit_answer', visible: true)

      fill_in 'Комментарий', with: comment.body
      click_on 'Добавить'
      expect(page).to have_content user.email
      expect(page).to have_content comment.body
      expect(page).to have_content 'Добавить комментарий'
      expect(page).to_not have_selector('.new_comment > .edit_answer', visible: true)
    end
  end

  scenario 'User try to leave invalid comment', js: true do
    sign_in(user)
    visit question_path(question)
    
    within "#answer-#{answer.id}" do
      click_on 'Добавить комментарий'
      fill_in 'Комментарий', with: ' '
      click_on 'Добавить'
      expect(page).to have_content("body can't be blank")
    end
  end

  given!(:first_comment) { create :comment, commentable: answer }
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


    
    
  
