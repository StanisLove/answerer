require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of  :email }
  it { should validate_presence_of  :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

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
        it "doesn't create new user" do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end

        it 'creates authorization for user' do
          expect { 
            User.find_for_oauth(auth) 
          }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end

      context "user doesn't exist and email given" do
        let(:auth)  { OmniAuth::AuthHash.new(provider: 'facebook', 
                                             uid: '123456', 
                                             info: {email: 'not@existed.com'}) }
        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'creates confirmed user' do
          expect(User.find_for_oauth(auth).confirmed?).to eq true
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          expect(User.find_for_oauth(auth).email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end

      context "user doesn't exist and email not given" do
        let(:auth)  { OmniAuth::AuthHash.new(provider: 'twitter', 
                                             uid: '123456') } 
        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'creates unconfirmed user' do
          expect(User.find_for_oauth(auth).confirmed?).to eq false
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email with fake email' do
          expect(User.find_for_oauth(auth).email).to eq "#{auth.uid}-#{auth.provider}@change.me"
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
