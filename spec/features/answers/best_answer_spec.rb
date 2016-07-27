require 'features_helper'

feature 'Best answer', '
  In order to mark an answer
  As the author of the question
  I want to be able to choose the best answer
' do

  given!(:question)      { create :question }
  given!(:first_answer)  { create :answer, question: question }
  given!(:second_answer) { create :answer, question: question }
  given!(:some_question) { create :question }
  given!(:some_answer)   { create :answer, question: some_question }

  describe "Authenticated user" do
    before do
      sign_in(question.user)
      visit question_path(question)
    end

    scenario "try to choose the best answer", js: true do
      expect(find(".answers > div:first-child").text).to have_content('Choose the Best')
        .and have_content first_answer.body

      expect(find(".answers > div:last-child").text).to have_content('Choose the Best')
        .and have_content second_answer.body

      find(".answers > div:last-child > .best-answer-link").click
      wait_for_ajax

      expect(find(".answers > div:first-child").text).to have_content('The Best Answer')
        .and have_content(second_answer.body)
        .and have_no_content 'Choose the Best'

      expect(find(".answers > div:last-child").text).to have_content('Choose the Best')
        .and have_content first_answer.body
    end

    scenario "try to choose the best answer for someone's quesiton", js: true do
      visit question_path(some_question)

      expect(page).to have_no_content('Choose the Best')
        .and have_no_content('The Best Answer')
        .and have_content some_answer.body
    end
  end

  scenario "Not authenticated user try to choose the best answer for someone's quesiton", js: true do
    visit question_path(some_question)

    expect(page).to have_no_content('Choose the Best')
      .and have_no_content('The Best Answer')
      .and have_content some_answer.body
  end
end
