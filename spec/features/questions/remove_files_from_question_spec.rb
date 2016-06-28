require 'features_helper'

feature 'Remove files from question', %q{
  In order to delete unnecessary files from question
  As an author of the question
  I'd like to be able to remove files
} do

  given!(:question) { create(:question) }

  background do
    sign_in(question.user)
    visit question_path(question)
  end

  scenario 'User remove file from the question', js: true do
    expect(page).to have_content 'Files'
    expect(page).to have_link    'spec_helper.rb',
        href: /^\/uploads\/attachment\/file\/\d+\/spec_helper\.rb$/
    expect(page).to have_content 'Delete'
    click_on 'Delete'
    wait_for_ajax

    expect(page).to_not have_content 'Files'
    expect(page).to_not have_link    'spec_helper.rb'
  end
end
