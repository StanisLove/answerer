require 'rails_helper'

describe 'Answers API' do
  let!(:question) { create :question }
  
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create :access_token }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path("question/answers")
      end

      %w(id body is_best created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(
            answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:answer) { create :answer, question: question }
    let!(:comment) { create :comment, commentable: answer }
    let!(:attachment) { create :attachment, attachable: answer }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create :access_token }

      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}",
               format: :json, access_token: access_token.token }

      it { expect(response).to be_success }
      it { expect(response.body).to have_json_size(1) }
      %w(id body is_best created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(
            answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(
              comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it "contains url" do
          expect(response.body).to be_json_eql(
            attachment.file.url.to_json).at_path("answer/attachments/0/url")
        end
      end
    end
  end
end
