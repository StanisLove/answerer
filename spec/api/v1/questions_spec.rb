require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create :access_token }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create :answer, question: question }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(
            question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(
              answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:question) { create :question }
    let!(:comment) { create :comment, commentable: question }
    let!(:attachment) { create :attachment, attachable: question }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create :access_token }

      before { get "/api/v1/questions/#{question.id}",
               format: :json, access_token: access_token.token }

      it { expect(response).to be_success }
      it { expect(response.body).to have_json_size(1) }
      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(
            question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(
              comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it "contains url" do
          expect(response.body).to be_json_eql(
            attachment.file.url.to_json).at_path("question/attachments/0/url")
        end
      end
    end
  end

  describe 'POST /create' do
    let!(:user) { create :user }
    let!(:access_token) { create :access_token, resource_owner_id: user.id }

    context 'unauthorized' do
      context 'there is no acess_token' do
        it 'does not create the question' do
          expect{
            post '/api/v1/questions', format: :json,
            question: attributes_for(:question)
          }.to_not change(Question, :count)
        end

        it 'returns 401 status' do
          post '/api/v1/questions', format: :json, 
            question: attributes_for(:question)
          expect(response.status).to eq 401
        end
      end

      context 'acess_token is invalid' do
        it 'does not create the question' do
          expect{
            post '/api/v1/questions', format: :json,
            question: attributes_for(:question), access_token: '1234'
          }.to_not change(Question, :count)
        end

        it 'returns 401 status' do
          post '/api/v1/questions', format: :json, 
            question: attributes_for(:question), access_token: '1234'
          expect(response.status).to eq 401
        end
      end
    end

    context 'authorized' do
      context 'with valid params' do
        it 'creates the question' do
          expect{
            post '/api/v1/questions', format: :json,
            question: attributes_for(:question), access_token: access_token.token
          }.to change(user.questions, :count).by(1)
        end

        it 'returns 201 status' do
          post '/api/v1/questions', format: :json, 
            question: attributes_for(:question), access_token: access_token.token
          expect(response.status).to eq 201
        end
      end
      
      context 'with invalid params' do
        it 'does not create the question' do
          expect{
            post '/api/v1/questions', format: :json,
            question: attributes_for(:invalid_question), access_token: access_token.token
          }.to_not change(Question, :count)
        end

        it 'returns 422 status' do
          post '/api/v1/questions', format: :json, 
            question: attributes_for(:invalid_question), access_token: access_token.token
          expect(response.status).to eq 422
        end
      end
    end
  end
end
