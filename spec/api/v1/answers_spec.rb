require 'rails_helper'

describe 'Answers API' do
  let!(:question) { create :question }

  describe 'GET /index' do
    let!(:access_token) { create :access_token }
    let!(:answers)      { create_list(:answer, 2, question: question) }
    let(:object)        { answers.first }

    it_behaves_like "API Authenticable"
    it_behaves_like "API Successable"
    it_behaves_like "API Sizable", 2, "question/answers"
    it_behaves_like "API Containable",
      %w(id body is_best created_at updated_at), "question/answers/0/"

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers",
        { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:answer) { create :answer, question: question }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:access_token) { create :access_token }
      let(:object)  { answer }

      it_behaves_like "API Successable"
      it_behaves_like "API Sizable", 1
      it_behaves_like "API Containable",
        %w(id body is_best created_at updated_at), "answer/"

      context 'comments' do
        let!(:object) { create :comment, commentable: answer }

        it_behaves_like "API Containable",
          %w(id body created_at updated_at), "answer/comments/0/"
      end

      context 'attachments' do
        let!(:attachment) { create :attachment, attachable: answer }
        let(:object)      { attachment.file }

        it_behaves_like "API Containable",
          %w(url), "answer/attachments/0/"
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
        { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let!(:user)         { create :user }
    let!(:access_token) { create :access_token, resource_owner_id: user.id }
    let(:model)         { Answer }

    it_behaves_like "API Authenticable"
    it_behaves_like "API Creatable"

    context 'authorized' do
      context 'with valid params' do
        it 'creates the answer to question' do
          expect{
            do_request(access_token: access_token.token)
          }.to  change(question.answers, :count).by(1)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers",
        { format: :json, question_id: question,
          answer: attributes_for(:answer) }.merge(options)
    end
  end
end
