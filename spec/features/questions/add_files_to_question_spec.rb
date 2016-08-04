require 'features_helper'

feature 'Add files to question', "
  In order to illustrate my question
  As an author of the question
  I'd like to be able to attach files
" do

  given(:user)     { create :user }
  given(:question) { build  :question }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds files when asks the question', js: true do
    fill_in 'Title',    with: question.title
    fill_in 'Question', with: question.body

    click_on    'Add one more file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add one more file'

    within '.attachments .nested-fields:last-child' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Ask Question'

    expect(page).to have_content 'Files'
    expect(page).to have_link    'spec_helper.rb',
                                 href: %r{/uploads\/attachment\/file\/\d+\/spec_helper\.rb$}
    expect(page).to have_link 'rails_helper.rb',
                              href: %r{/uploads\/attachment\/file\/\d+\/rails_helper\.rb$}
  end

  scenario 'User can add and then revmove file while creating an answer', js: true do
    fill_in     'Title',    with: question.title
    fill_in     'Question', with: question.body
    click_on    'Add one more file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    expect(page).to have_content 'Delete File'

    click_on 'Delete File'
    click_on 'Ask Question'
    wait_for_ajax

    within '.question' do
      expect(page).not_to have_link    'spec_helper.rb'
      expect(page).not_to have_content 'Files'
    end
  end

  scenario "User doesn't add file when asks the quesion" do
    fill_in  'Title',    with: question.title
    fill_in  'Question', with: question.body
    click_on 'Ask Question'
    expect(page).not_to have_content 'Files'
  end
end
