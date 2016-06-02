require 'features_helper'

feature 'Vote for the answer', %{
  In order to choose good or bad answer
  As an user
  I'd like to be able to vote for the answer
} do

  given!(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question) }
  given(:user) { create(:user) }
  
  scenario 'User vote up for the answer and then vote down', js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{answer.id} > .vote" do
      expect(page).to have_content('+')
                  .and have_content('–')
                  .and have_content('0')

      click_on '+'

      expect(page).to have_no_content('+')
                  .and have_no_content('–')
                  .and have_content('1')
                  .and have_content('Отменить')

      click_on 'Отменить'

      expect(page).to have_content('+')
                  .and have_content('–')
                  .and have_content('0')
                  .and have_no_content('Отменить')

      click_on '–'

      expect(page).to have_no_content('+')
                  .and have_no_content('–')
                  .and have_content('-1')
                  .and have_content('Отменить')
    end
  end

  scenario 'The author try to vote for the own answer', js: true do
    sign_in(answer.user)
    visit question_path(question)
    
    within "#answer-#{answer.id} > .vote" do
      expect(page).to have_no_content('+')
                  .and have_no_content('–')
                  .and have_content('0')
                  .and have_no_content('Отменить')
    end
  end

  given(:answer_with_vote) { create(:answer, question: question) }
  given(:voted_user) { create(:user) }
  given!(:vote) { create(:vote_up, user_id: voted_user.id,
                         votable: answer_with_vote) }

  scenario 'Voted user visit answer again', js: true do
    sign_in(voted_user)
    visit question_path(question)

    within "#answer-#{answer_with_vote.id} > .vote" do
      expect(page).to have_no_content('+')
                  .and have_no_content('–')
                  .and have_content('1')
                  .and have_content('Отменить')
    end
  end
end
