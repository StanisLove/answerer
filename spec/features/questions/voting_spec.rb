require 'features_helper'

feature 'Vote for the question', %{
  In order to choose good or bad questions
  As an user
  I'd like to be able to vote for the question
} do

  given!(:question) { create(:question) }
  given(:user)      { create(:user) }

  scenario 'User vote up for the question and then vote down two times', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question > .vote' do
      expect(page).to  have_content('+')
                  .and have_content('–')
                  .and have_content('0')

      click_on '+'

      expect(page).to  have_no_content('+')
                  .and have_no_content('–')
                  .and have_content('1')
                  .and have_content('Отменить')

      click_on 'Отменить'

      expect(page).to  have_content('+')
                  .and have_content('–')
                  .and have_content('0')
                  .and have_no_content('Отменить')

      click_on '–'

      expect(page).to  have_no_content('+')
                  .and have_no_content('–')
                  .and have_content('-1')
                  .and have_content('Отменить')
    end
  end

  scenario 'The author try to vote for the own question', js: true do
    sign_in(question.user)
    visit question_path(question)

    within '.question > .vote' do
      expect(page).to  have_no_content('+')
                  .and have_no_content('–')
                  .and have_content('0')
                  .and have_no_content('Отменить')
    end
  end

  given(:question_with_vote) { create(:question) }
  given(:voted_user)         { create(:user) }
  given!(:vote)              { create(:vote_up, user_id: voted_user.id,
                                                votable: question_with_vote) }

  scenario 'Voted user visit question again', js: true do
    sign_in(voted_user)
    visit question_path(question_with_vote)

    within '.question > .vote' do
      expect(page).to  have_no_content('+')
                  .and have_no_content('–')
                  .and have_content('1')
                  .and have_content('Отменить')
    end
  end
end
