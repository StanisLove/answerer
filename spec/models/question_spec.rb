require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like "attachable"
  it_behaves_like "votable"
  it_behaves_like "commentable"

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should have_db_index :user_id }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions) }

  it { should validate_presence_of  :title }
  it { should validate_presence_of  :body }
  it { should validate_length_of(:title).is_at_most(140) }
  it { should validate_presence_of :user_id }

  it { should accept_nested_attributes_for :attachments }

  describe '.subscribe_author' do
    let(:question) { create :question }

    it 'is called after creating' do
      expect(Subscription.where(user: question.user, question: question)).to exist
    end
  end
end
