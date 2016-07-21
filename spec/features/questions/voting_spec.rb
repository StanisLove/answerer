require 'features_helper'

feature 'Vote for the question', %{
  In order to choose good or bad questions
  As an user
  I'd like to be able to vote for the question
} do

  given!(:question) { create(:question) }
  given(:user)      { create(:user) }

  it_behaves_like "vote feature" do
    given(:votable_selector) { '.question > .vote' }
    given(:votable)          { question }
  end
end
