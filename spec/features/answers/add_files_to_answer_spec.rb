require 'features_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As author of the answer
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { build(:answer) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when create answer' do
    fill_in 'Новый ответ',  with: answer.body
    attach_file 'Файл', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Отправить ответ'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/1/spec_helper.rb"
    end
  end

end
