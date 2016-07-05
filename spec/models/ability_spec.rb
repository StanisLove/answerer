require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe "Guest abilities" do
    let(:user) { nil }
    it_behaves_like "Guestable"
  end

  describe "Admin abilities" do
    let(:user) { create :user, admin: true }
    it { should be_able_to :manage, :all }
  end

  describe "User abilities" do
    let(:user) { create :user }

    it_behaves_like "Guestable"

    context "with question" do
      it { should be_able_to :create, Question }

      context "when is an author" do
        let(:object) { create :question, user: user }
        it_behaves_like "Author", true
      end

      context "when is not an author" do
        let(:object) { create :question }
        it_behaves_like "Author", false
      end
    end

    context "with answer" do
      it { should be_able_to :create, Answer }

      context "when is an author" do
        let(:object) { create :answer, user: user }
        it_behaves_like "Author", true
      end

      context "when is not an author" do
        let(:object) { create :answer }
        it_behaves_like "Author", false
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
      it { should be_able_to :me,    :profile, user: user }
      it { should be_able_to :index, :profile, user: user }
    end

    context "with subscription" do
      it { should be_able_to :create, Subscription }

      context "when it was created" do
        let(:subscription) { create :subscription, user: user }

        it { should be_able_to :destroy, subscription, user: user }
      end
    end
  end
end
