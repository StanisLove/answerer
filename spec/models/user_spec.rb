require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of  :email }
  it { should validate_presence_of  :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authentication' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(described_class.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user already exist' do
        let(:auth)  do
          OmniAuth::AuthHash.new(provider: 'facebook',
                                 uid: '123456',
                                 info: { email: user.email })
        end
        it_behaves_like "may be authorized"
      end

      context "user signed in" do
        let(:auth)  do
          OmniAuth::AuthHash.new(provider: 'facebook',
                                 uid: '123456',
                                 info: { email: 'not@existed.com' })
        end
        it_behaves_like "may be authorized"

        it "doesn't change user email" do
          expect { described_class.find_for_oauth(auth, user) }.not_to change(user, :email)
        end
      end

      context "user doesn't exist and email given by provider" do
        let(:auth)  do
          OmniAuth::AuthHash.new(provider: 'facebook',
                                 uid: '123456',
                                 info: { email: 'not@existed.com' })
        end
        let(:user_email) { nil }

        it_behaves_like 'authorization can be create'

        it 'creates confirmed authorization' do
          expect(
            described_class.find_for_oauth(auth).authorizations.find_by(uid: auth.uid).confirmed_at?
          ).to eq true
        end

        it 'fills user email' do
          expect(described_class.find_for_oauth(auth).email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = described_class.find_for_oauth(auth)
          expect(user.authorizations).not_to be_empty
        end
      end

      context "user doesn't exist and email not given" do
        let(:auth)  do
          OmniAuth::AuthHash.new(provider: 'twitter',
                                 uid: '123456')
        end
        it "it doesn't create new user" do
          expect { described_class.find_for_oauth(auth) }.not_to change(described_class, :count)
        end

        it "returns nil" do
          expect(described_class.find_for_oauth(auth)).to eq nil
        end
      end

      context "user doesn't exist and email given by user" do
        let(:auth)  do
          OmniAuth::AuthHash.new(provider: 'twitter',
                                 uid: '123456')
        end
        let(:user_email) { 'given_by_user@email.com' }

        it_behaves_like 'authorization can be create'

        it 'creates unconfirmed authorization' do
          expect(
            described_class.find_for_oauth(auth, user_email).authorizations.find_by(uid: auth.uid).confirmed_at?
          ).to eq false
        end

        it 'fills user email' do
          expect(described_class.find_for_oauth(auth, user_email).email).to eq user_email
        end
      end
    end
  end
end
