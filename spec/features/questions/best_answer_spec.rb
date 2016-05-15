require 'features_helper'

feature 'Best answer', %q{
  In order to highlight an answer
  As the author of the question
  I want to be able to choose the best answer
} do

  given!(:question) { create(:question) }
  given!(:first_answer)   { create(:answer, question: question) }
  given!(:second_answer)  { create(:answer, question: question) }

  describe "Authenticated user" do
    before do
      sign_in(question.user)
      visit question_path(question)
    end

    scenario "try to choose the best answer" do
      expect(find(".answers > div:first-child").text).to  have_content('Выбрать лучшим ответом')
                                                          .and have_content(first_answer.body)
      expect(find(".answers > div:last-child").text).to   have_content('Выбрать лучшим ответом')
                                                          .and have_content(second_answer.body)

      find(".answers > div:last-child > .best-answer-link").click

      expect(find(".answers > div:first-child").text).to  have_content('Лучший ответ')
                                                          .and have_content(second_answer.body)
                                                          .and have_no_content('Выбрать лучшим ответом')


    end
  end
end
