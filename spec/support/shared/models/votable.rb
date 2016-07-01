require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  context "with vote_up! method" do
    it "user can vote for the #{described_class.to_s.downcase} only one time" do
      vote(:vote_up!, user, 1)
      vote(:vote_up!, user, 1)
    end

    it "the author can't vote for the #{described_class.to_s.downcase}" do
      vote(:vote_up!, model.user, 0)
    end
  end

  context "with vote_down! method" do
    it "user can vote against the #{described_class.to_s.downcase} only one time" do
      vote(:vote_down!, user, -1)
      vote(:vote_down!, user, -1)
    end

    it "the author can't vote against the #{described_class.to_s.downcase}" do
      vote(:vote_down!, model.user, 0)
    end
  end

  context "with vote_reset! method" do
    it "user can cancel the vote and revote" do
      vote(:vote_up!, user, 1)
      vote(:vote_reset!, user, 0)
      vote(:vote_down!, user, -1)
    end
  end

  def vote(method, user, result)
    model.send(method, user)
    model.reload
    expect(model.voting_result).to eq result
  end
end
