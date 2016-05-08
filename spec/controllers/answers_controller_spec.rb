require 'rails_helper'

RSpec::Matchers.define_negated_matcher  :not_change, :change

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 2) }
    before { get  :index, question_id: question }

    it 'fills the array of questons' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get  :new, question_id: question }

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let(:answer) { create(:answer) }
    before { get  :show, id: answer, question_id: question }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new answer into DB' do
        expect{
          post  :create, question_id: question, answer: attributes_for(:answer)
        }.to  change(question.answers,  :count).by(1)
              .and change(@user.answers,:count).by(1) 
      end
      
      it 'redirects to show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_answer_path(assigns(:question), assigns(:answer))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer into DB' do
        expect{
          post  :create, question_id: question, answer: attributes_for(:invalid_answer)
        }.to  not_change(question.answers,  :count)
              .and not_change(@user.answers,:count)
      end

      it 're-renders new view' do
        post  :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:answer) { create(:answer,
                           user_id: @user.id) }
    
    it 'deletes the answer from DB' do
      expect{
        delete :destroy, id: answer, question_id: question
      }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, id: answer, question_id: question
      expect(response).to redirect_to question_answers_path(question)
    end
  end
end
