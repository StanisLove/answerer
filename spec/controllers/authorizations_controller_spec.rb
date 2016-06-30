require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do

  describe 'GET #confirm' do
    let!(:authorization) { create(:authorization) }

    context "with valid token" do
      it 'makes authorization confirmed' do
        get :confirm, id: authorization, token: authorization.confirmation_token
        authorization.reload
        expect(authorization.confirmed_at?).to eq true
      end
    end

    context "witn invalid token" do
      it "doesn't make authorization confirmed" do
        get :confirm, id: authorization, token: Devise.friendly_token
        authorization.reload
        expect(authorization.confirmed_at?).to eq false
      end
    end
  end

  describe 'POST #create' do
    context 'with valid provider data' do
      before { session["devise.provider_data"] = { provider: 'twitter', uid: '123456' } }

      it "sends email confirmation" do
        expect {
          post :create, authorization: { email: "user@email.com" }
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end

    context 'with invalid provider data' do
      before { session["devise.provider_data"] = { provider: nil, uid: nil } }

      it "doesn't send email confirmation" do
        expect {
          post :create, authorization: { email: "user@email.com" }
        }.to_not change(ActionMailer::Base.deliveries, :count)
      end
    end

    context 'with invalid email' do
      before { session["devise.provider_data"] = { provider: 'twitter', uid: '123456' } }

      it "doesn't send email confirmation" do
        expect {
          post :create, authorization: { email: "invalid" }
        }.to_not change(ActionMailer::Base.deliveries, :count)
      end
    end
  end
end
