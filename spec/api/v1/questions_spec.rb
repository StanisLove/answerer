require 'rails_helper'

describe 'Questions API' do
  describe 'GET #index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:access_token)  { create :access_token }
      let!(:questions)      { create_list :question, 2 }
      let(:object) { questions.first }

      it_behaves_like "API Containable",
        %w(id title body created_at updated_at), "questions/0/"

      before { do_request(access_token: access_token.token) }

      it { expect(response).to be_success }
      it { expect(response.body).to have_json_size(2).at_path("questions") }

      context 'answers' do
        let!(:object)  { create(:answer, question: questions.first) }

        it_behaves_like "API Containable",
          %w(id body created_at updated_at),
          "questions/0/answers/0/"

        before { do_request(access_token: access_token.token) }
        it { expect(response.body).to have_json_size(1).
                                      at_path("questions/0/answers") }
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:question) { create :question }
    let(:object)    { question }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:access_token) { create :access_token }

      it_behaves_like "API Containable",
        %w(id title body created_at updated_at), "question/"

      before { do_request(access_token: access_token.token) }

      it { expect(response).to be_success }
      it { expect(response.body).to have_json_size(1) }

      context 'comments' do
        let!(:object) { create :comment, commentable: question }

        it_behaves_like "API Containable",
          %w(id body created_at updated_at),
          "question/comments/0/"
      end

      context 'attachments' do
        let!(:attachment) { create :attachment, attachable: question }
        let(:object)      { attachment.file }

        it_behaves_like "API Containable", %w(url), "question/attachments/0/"
      end
    end

    def do_request(options = {} )
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let!(:user)         { create :user }
    let!(:access_token) { create :access_token, resource_owner_id: user.id }
    let(:model)         { Question }

    it_behaves_like "API Authenticable"
    it_behaves_like "API Creatable"

    def do_request(options = {})
      post '/api/v1/questions',
        { format: :json, question: attributes_for(:question) }.merge(options)
    end
  end
end
