require 'features_helper'

feature 'Remove files from question', "
  In order to delete unnecessary files from question
  As an author of the question
  I'd like to be able to remove files
" do

  given!(:question) { create(:question) }

  background do
    sign_in(question.user)
    visit question_path(question)
  end

  scenario 'User remove file from the question', js: true do
    expect(page).to have_content 'Files'
    expect(page).to have_link    'spec_helper.rb',
                                 href: %r{/uploads\/attachment\/file\/\d+\/spec_helper\.rb$}
    expect(page).to have_content 'Delete'
    click_on 'Delete'
    wait_for_ajax

    expect(page).not_to have_content 'Files'
    expect(page).not_to have_link    'spec_helper.rb'
  end
end
