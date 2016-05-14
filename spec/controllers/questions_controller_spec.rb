require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get  :index }

    it 'fills the array of questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
      
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get  :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    before { get  :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question into DB' do
        expect{
          post  :create, question: attributes_for(:question)
        }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post  :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new question into DB' do
        expect{
          post  :create, question: attributes_for(:invalid_question)
        }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post  :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:question) { create(:question, user: @user) }

    it 'assigns the request question to @question' do
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      patch :update, id: question, question: { title: 'new title', body: 'new body' }, format: :js
      question.reload
      expect(question.title).to eq 'new title'
      expect(question.body).to eq 'new body'
    end

    it 'renders update template' do
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:question) { create(:question, user_id: @user.id) }

    it 'deletes the question from DB'do
      expect{
        delete :destroy, id: question
      }.to change(@user.questions, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end
end
