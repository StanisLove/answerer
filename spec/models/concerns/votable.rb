require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { create(described_class.to_s.underscore.to_sym) }
  let!(:vote) { create(:vote_up, votable: model) }

  it "voice" do
    expect(model.votes.first.voice).to eq true
  end
end
