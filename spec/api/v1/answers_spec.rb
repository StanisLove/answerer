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

  describe 'POST /create' do
    let!(:user) { create :user }
    let!(:access_token) { create :access_token, resource_owner_id: user.id }

    context 'unauthorized' do
      context 'there is no acess_token' do
        it 'does not create the answer' do
          expect{
            post "/api/v1/questions/#{question.id}/answers", format: :json, question_id: question,
            answer: attributes_for(:answer)
          }.to_not change(Answer, :count)
        end

        it 'returns 401 status' do
          post "/api/v1/questions/#{question.id}/answers", format: :json, question_id: question,
            question: attributes_for(:question)
          expect(response.status).to eq 401
        end
      end

      context 'acess_token is invalid' do
        it 'does not create the question' do
          expect{
            post "/api/v1/questions/#{question.id}/answers", format: :json, question_id: question,
            answer: attributes_for(:answer), access_token: '1234'
          }.to_not change(Answer, :count)
        end

        it 'returns 401 status' do
          post "/api/v1/questions/#{question.id}/answers", format: :json, question_id: question, 
            answer: attributes_for(:answer), access_token: '1234'
          expect(response.status).to eq 401
        end
      end
    end

    context 'authorized' do
      context 'with valid params' do
        it 'creates the answer' do
          expect{
            post "/api/v1/questions/#{question.id}/answers", format: :json, question_id: question,
            answer: attributes_for(:answer), access_token: access_token.token
          }.to change(user.answers, :count).by(1)
              .and change(question.answers, :count).by(1)
          
        end

        it 'returns 201 status' do
          post "/api/v1/questions/#{question.id}/answers", format: :json,
            answer: attributes_for(:answer), access_token: access_token.token, question_id: question
          expect(response.status).to eq 201
        end
      end
      
      context 'with invalid params' do
        it 'does not create the answer' do
          expect{
            post "/api/v1/questions/#{question.id}/answers", format: :json, question_id: question,
            answer: attributes_for(:invalid_answer), access_token: access_token.token
          }.to_not change(Answer, :count)
        end

        it 'returns 422 status' do
          post "/api/v1/questions/#{question.id}/answers", format: :json, question_id: question,
            answer: attributes_for(:invalid_answer), access_token: access_token.token
          expect(response.status).to eq 422
        end
      end
    end
  end
end
