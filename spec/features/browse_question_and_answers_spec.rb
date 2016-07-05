require 'features_helper'

feature 'User browse question and answers', %q{
  In order to find correct answer
  As an user
  I want to be able to browse answers the question
} do

  given!(:question)                 { create      :question }
  given!(:answers)                  { create_list :answer,  2, question_id: question.id }
  given!(:question_with_out_answer) { create      :question }

  scenario 'User try to browse answers the question' do
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |a|
      expect(page).to have_content a.body
    end
    expect(current_path).to eq question_path question
  end

  scenario 'User try to browse question with out answer' do
    visit question_path question_with_out_answer
    expect(page).to have_content question_with_out_answer.title
    expect(page).to have_content question_with_out_answer.body
    expect(page).to_not have_css "div.answers > div"
  end
end
