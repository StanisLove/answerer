require 'features_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an author of the question
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { build(:question) }
  
  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds files when asks the question', js: true do
    fill_in 'Заголовок',  with: question.title
    fill_in 'Вопрос',     with: question.body

    click_on 'Добавить ещё один файл'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Добавить ещё один файл'
    within '.attachments .nested-fields:last-child' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Спросить'

    expect(page).to have_content 'Файлы'
    expect(page).to have_link 'spec_helper.rb',
        href: /^\/uploads\/attachment\/file\/\d+\/spec_helper\.rb$/
    expect(page).to have_link 'rails_helper.rb',
        href: /^\/uploads\/attachment\/file\/\d+\/rails_helper\.rb$/
  end

  scenario 'User can add and then revmove file while creating an answer', js: true do
    fill_in 'Заголовок',  with: question.title
    fill_in 'Вопрос',     with: question.body

    click_on 'Добавить ещё один файл'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    expect(page).to have_content 'Удалить файл'

    click_on 'Удалить файл'
    click_on 'Спросить'
    wait_for_ajax

    within '.question' do
      expect(page).to_not have_link 'spec_helper.rb'
      expect(page).to_not have_content 'Файлы'
    end
  end

  scenario "User doesn't add file when asks the quesion" do
    fill_in 'Заголовок',  with: question.title
    fill_in 'Вопрос',     with: question.body
    click_on 'Спросить'
    expect(page).to_not have_content 'Файлы'
  end
end
