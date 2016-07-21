shared_examples "vote feature" do
  scenario 'User vote up for the question and then vote down', js: true do
    sign_in(user)
    visit question_path(question)

    within votable_selector do
      expect(page).to  have_content('+')
                  .and have_content('–')
                  .and have_content('0')

      click_on '+'

      expect(page).to  have_no_content('+')
                  .and have_no_content('–')
                  .and have_content('1')
                  .and have_content('Отменить')

      click_on 'Отменить'

      expect(page).to  have_content('+')
                  .and have_content('–')
                  .and have_content('0')
                  .and have_no_content('Отменить')

      click_on '–'

      expect(page).to  have_no_content('+')
                  .and have_no_content('–')
                  .and have_content('-1')
                  .and have_content('Отменить')
    end
  end

  context "vote existed" do
    given!(:vote) { create(:vote_up, votable: votable) }

    scenario 'Voted user visit question again', js: true do
      sign_in(vote.user)
      visit question_path(question)

      within votable_selector do
        expect(page).to  have_no_content('+')
                    .and have_no_content('–')
                    .and have_content('1')
                    .and have_content('Отменить')
      end
    end
  end

  context 'as author' do
    background do
      sign_in(votable.user)
      visit question_path(question)
    end

    it_behaves_like "cannot vote for"
  end

  context 'as guest' do
    background { visit question_path question }
    it_behaves_like "cannot vote for"
  end
end

shared_examples "cannot vote for" do
  scenario "sees no links", js: true do
    within votable_selector do
      expect(page).to  have_no_content('+')
                  .and have_no_content('–')
                  .and have_content('0')
                  .and have_no_content('Отменить')
    end
  end
end
