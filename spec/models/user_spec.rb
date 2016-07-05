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
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user already exist' do
        let(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook',
                                                  uid: '123456',
                                                 info: {email: user.email}) }
        it_behaves_like "may be authorized"
      end

      context "user signed in" do
        let(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook',
                                                  uid: '123456',
                                                 info: {email: 'not@existed.com'}) }
        it_behaves_like "may be authorized"

        it "doesn't change user email" do
          expect { User.find_for_oauth(auth, user) }.to_not change(user, :email)
        end
      end

      context "user doesn't exist and email given by provider" do
        let(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook',
                                                  uid: '123456',
                                                 info: {email: 'not@existed.com'}) }
        let(:user_email) { nil }

        it_behaves_like 'authorization can be create'

        it 'creates confirmed authorization' do
          expect(
            User.find_for_oauth(auth).authorizations.find_by(uid: auth.uid).confirmed_at?
          ).to eq true
        end

        it 'fills user email' do
          expect(User.find_for_oauth(auth).email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end
      end

      context "user doesn't exist and email not given" do
        let(:auth)  { OmniAuth::AuthHash.new(provider: 'twitter',
                                                  uid: '123456') }
        it "it doesn't create new user" do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it "returns nil" do
          expect(User.find_for_oauth(auth)).to eq nil
        end
      end

      context "user doesn't exist and email given by user" do
        let(:auth)  { OmniAuth::AuthHash.new(provider: 'twitter',
                                                  uid: '123456') }
        let(:user_email) { 'given_by_user@email.com' }

        it_behaves_like 'authorization can be create'

        it 'creates unconfirmed authorization' do
          expect(
            User.find_for_oauth(auth, user_email).authorizations.find_by(uid: auth.uid).confirmed_at?
          ).to eq false
        end

        it 'fills user email' do
          expect(User.find_for_oauth(auth, user_email).email).to eq user_email
        end
      end
    end
  end
end
