require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let!(:vote) { create(:vote_up, votable: model) }

  it "#voice" do
    expect(model.votes.first.voice).to eq true
  end

  let(:question) { create(:question) }
  let(:user) { create(:user) }

  context "with vote_up! mehtod" do
    it "user can vote for the question only one time" do 
      question.vote_up!(user)
      question.reload
      expect(question.voting_result).to eq 1

      question.vote_up!(user)
      question.reload
      expect(question.voting_result).to eq 1
    end

    it "the author can't vote for the question" do
      question.vote_up!(question.user)
      question.reload
      expect(question.voting_result).to eq 0
    end
  end

  context "with vote_down! mehtod" do
    it "user can vote against the question only one time" do 
      question.vote_down!(user)
      question.reload
      expect(question.voting_result).to eq -1

      question.vote_down!(user)
      question.reload
      expect(question.voting_result).to eq -1
    end

    it "the author can't vote against the question" do
      question.vote_down!(question.user)
      question.reload
      expect(question.voting_result).to eq 0
    end
  end

  context "with vote_reset! method" do
    it "user can cancel the vote and revote" do
      question.vote_up!(user)
      question.reload
      expect(question.voting_result).to eq 1

      question.vote_reset!(user)
      question.reload
      expect(question.voting_result).to eq 0

      question.vote_down!(user)
      question.reload
      expect(question.voting_result).to eq -1
    end
  end
end
