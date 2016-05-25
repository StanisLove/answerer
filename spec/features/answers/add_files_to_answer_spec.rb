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

  scenario 'User adds files when create answer', js: true do
    within '.answers' do
      expect(page).to_not have_content 'Файлы'
    end

    fill_in 'Новый ответ',  with: answer.body
    click_on 'Добавить ещё один файл'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Добавить ещё один файл'
    within '.attachments .nested-fields:last-child' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Отправить ответ'
    wait_for_ajax
    
    within '.new_answer' do
      expect(page).to_not have_content("#{answer.body}")
    end
    within '.answers' do
      expect(page).to have_content 'Файлы'
      expect(page).to have_link 'spec_helper.rb',
        href: /^\/uploads\/attachment\/file\/\d+\/spec_helper\.rb$/
      expect(page).to have_link 'rails_helper.rb',
        href: /^\/uploads\/attachment\/file\/\d+\/rails_helper\.rb$/
    end
  end

  scenario 'User can add and then revmove file while creating an answer', js: true do
    fill_in 'Новый ответ',  with: answer.body
    click_on 'Добавить ещё один файл'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    expect(page).to have_content 'Удалить файл'

    click_on 'Удалить файл'
    click_on 'Отправить ответ'
    wait_for_ajax
    
    within '.answers' do
      expect(page).to_not have_link 'spec_helper.rb'
      expect(page).to_not have_content 'Файлы'
    end
  end
end
