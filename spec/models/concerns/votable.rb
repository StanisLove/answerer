require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  context "with vote_up! mehtod" do
    it "user can vote for the #{described_class.to_s.downcase} only one time" do 
      model.vote_up!(user)
      model.reload
      expect(model.voting_result).to eq 1

      model.vote_up!(user)
      model.reload
      expect(model.voting_result).to eq 1
    end

    it "the author can't vote for the #{described_class.to_s.downcase}" do
      model.vote_up!(model.user)
      model.reload
      expect(model.voting_result).to eq 0
    end
  end

  context "with vote_down! mehtod" do
    it "user can vote against the #{described_class.to_s.downcase} only one time" do 
      model.vote_down!(user)
      model.reload
      expect(model.voting_result).to eq -1

      model.vote_down!(user)
      model.reload
      expect(model.voting_result).to eq -1
    end

    it "the author can't vote against the #{described_class.to_s.downcase}" do
      model.vote_down!(model.user)
      model.reload
      expect(model.voting_result).to eq 0
    end
  end

  context "with vote_reset! method" do
    it "user can cancel the vote and revote" do
      model.vote_up!(user)
      model.reload
      expect(model.voting_result).to eq 1

      model.vote_reset!(user)
      model.reload
      expect(model.voting_result).to eq 0

      model.vote_down!(user)
      model.reload
      expect(model.voting_result).to eq -1
    end
  end
end
