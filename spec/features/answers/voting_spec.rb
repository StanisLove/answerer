require 'features_helper'

feature 'Vote for the answer', %(
  In order to choose good or bad answer
  As an user
  I'd like to be able to vote for the answer
) do

  given!(:question) { create(:question) }
  given!(:answer)   { create(:answer, question: question) }
  given(:user)      { create(:user) }

  it_behaves_like "vote feature" do
    let(:votable_selector) { "#answer-#{answer.id} > .vote" }
    let(:votable)          { answer }
  end
end
