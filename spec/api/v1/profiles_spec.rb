require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:me)           { create :user }
      let(:object)        { me }
      let!(:access_token) { create :access_token, resource_owner_id: me.id }

      it_behaves_like "API Successable"
      it_behaves_like "API Containable", %w(email id created_at updated_at admin),
        '', %w(password password_confirmation encrypted_password)
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:users)        { create_list(:user, 2) }
      let(:object)        { users.first }
      let!(:me)           { create :user }
      let!(:access_token) { create :access_token, resource_owner_id: me.id }

      it_behaves_like "API Successable"
      it_behaves_like "API Sizable", 2, ''
      it_behaves_like "API Containable",
        %w(email id created_at updated_at admin),
        '0/', %w(password password_confirmation encrypted_password)

      before { do_request(access_token: access_token.token) }

      it "doesn't contain me" do
        expect(response.body).to_not include_json(me.to_json)
      end

      it { expect(response.body).to have_json_path('0/email') }
    end

    def do_request(options = {})
      get '/api/v1/profiles', { format: :json }.merge(options)
    end
  end
end
