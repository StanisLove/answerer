require 'features_helper'

feature 'Remove files from answer', %q{
  In order to delete unnecessary files from answer
  As an author of the answer
  I'd like to be able to remove files
} do

  given!(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question) }
  
  background do
    sign_in(answer.user)
    visit question_path(question)
  end

  scenario 'User remove file from the answer', js: true do
    within '.answers' do
      expect(page).to have_content 'Файлы'
      expect(page).to have_link 'spec_helper.rb',
        href: /^\/uploads\/attachment\/file\/\d+\/spec_helper\.rb$/
      expect(page).to have_content 'Удалить'
      click_on 'Удалить'
      wait_for_ajax

      expect(page).to_not have_content 'Файлы'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end
end