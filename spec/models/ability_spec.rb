require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe "Guest abilities" do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe "Admin abilities" do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe "User abilities" do
    let(:user) { create :user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context "with question" do
      it { should be_able_to :create, Question }

      context "when is an author" do
        let(:question) { create :question, user: user }
        it { should be_able_to :update, question, user: user }
        it { should_not be_able_to :vote_up, question, user: user }
        it { should_not be_able_to :vote_down, question, user: user }
        it { should_not be_able_to :vote_reset, question, user: user }
        it { should be_able_to :destroy, question, user: user }
      end
      

      context "when is not an author" do
        let(:question) { create :question }
        it { should_not be_able_to :update, question, user: user }
        it { should be_able_to :vote_up, question, user: user }
        it { should be_able_to :vote_down, question, user: user }
        it { should be_able_to :vote_reset, question, user: user }
        it { should_not be_able_to :destroy, question, user: user }
      end
    end

    context "with answer" do
      it { should be_able_to :create, Answer }

      context "when is an author" do
        let(:answer) { create :answer, user: user }
        it { should be_able_to :update, answer, user: user }
        it { should_not be_able_to :vote_up, answer, user: user }
        it { should_not be_able_to :vote_down, answer, user: user }
        it { should_not be_able_to :vote_reset, answer, user: user }
        it { should be_able_to :destroy, answer, user: user }
      end

      context "when is not an author" do
        let(:answer) { create :answer }
        it { should_not be_able_to :update, answer, user: user }
        it { should be_able_to :vote_up, answer, user: user }
        it { should be_able_to :vote_down, answer, user: user }
        it { should be_able_to :vote_reset, answer, user: user }
        it { should_not be_able_to :destroy, answer, user: user }
      end

      context "when is an author of anser's question" do
        let(:answer) { create :answer, question: create(:question, user: user) }
        it { should be_able_to :choose_best, answer, user: user }
      end

      context "when is not an author of answer's question" do
        let(:answer) { create :answer }
        it { should_not be_able_to :choose_best, answer, user: user }
      end
    end

    context "with comment" do
      it { should be_able_to :create, Comment }
    end

    context "with profile" do
      it { should be_able_to :me, :profile, user: user }
      it { should be_able_to :index, :profile, user: user }
    end
  end
end
