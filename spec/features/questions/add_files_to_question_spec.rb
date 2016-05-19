require 'features_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an author of the question
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  
  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks the question' do
    fill_in 'Заголовок',  with: question.title
    fill_in 'Вопрос',     with: question.body
    attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Спросить'

    expect(page).to have_content 'spec_helper.rb'
  end
end
